resource "aws_instance" "web_server" {
  ami     = "ami-0e86e20dae9224db8"
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.http_ssh_sg_id
  key_name = aws_key_pair.deployer.key_name
  
  user_data = <<-EOF
        #!/bin/bash
              useradd -m -s /bin/bash indiehacker
              echo "indiehacker:${var.user_password}" | chpasswd
              echo "indiehacker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

              mkdir -p /home/indiehacker/.ssh
              echo "${var.ssh_public_key}" >> /home/indiehacker/.ssh/authorized_keys
              chown -R indiehacker:indiehacker /home/indiehacker/.ssh
              chmod 700 /home/indiehacker/.ssh
              chmod 600 /home/indiehacker/.ssh/authorized_keys

              # Allow password authentication (optional, remove if you want key-based auth only)
              sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              systemctl restart sshd
              echo "DB_HOST=${var.db_host}" >> /home/indiehacker/.env
              echo "DB_NAME=${var.db_name}" >> /home/indiehacker/.env
              echo "DB_USER=${var.db_username}" >> /home/indiehacker/.env
              echo "DB_PASSWORD=${var.db_password}" >> /home/indiehacker/.env
              EOF

  tags = {
    Name = "webserver-staging"
    Environment = "Staging"
    }
}

resource "aws_eip" "eip" {
  instance = aws_instance.web_server.id
  domain   = "vpc"
  tags = {
    Name = "test-eip01"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.ssh_public_key
}

###### LAUNCH CONFIGURATION ######
resource "aws_launch_configuration" "testlauncher" {
  name_prefix   = "terraform-lconf-"
  image_id     = "ami-0e86e20dae9224db8"
  instance_type = var.instance_type
  security_groups = var.http_ssh_sg_id
  associate_public_ip_address = true
  key_name      = aws_key_pair.deployer.key_name

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World <p>DB address: ${var.db_host}</p>" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              echo "nohup busybox httpd -f -p ${var.server_port} &" >> /etc/rc.local
              chmod +x /etc/rc.local
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

###### AUTOSCALING GROUP #######

resource "aws_autoscaling_group" "testASG" {
  launch_configuration = aws_launch_configuration.testlauncher.name
  # availability_zones  = data.aws_availability_zones.available.names

  load_balancers   = [aws_elb.elastic_lb.name]
  health_check_type  = "ELB"
  min_size          = 1
  max_size          = 1
  desired_capacity  = 1
  vpc_zone_identifier = [var.elb_subnet_ids]

  tag {
    key                 = "Name"
    value               = "ASG Dev"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

###### Elastic load balancer creation #######

resource "aws_elb" "elastic_lb" {
  name               = "test-ELB01"
  subnets = [var.elb_subnet_ids]
  # availability_zones = data.aws_availability_zones.available.names
  security_groups = var.elb_sg_id

  listener {
    instance_port     = var.server_port
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.server_port}/"
    interval            = 30
  }
}