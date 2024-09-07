provider "aws" {
  region = "us-east-1"
}


variable "server_port" { 
    description = "The intended server port for HTTP requests"
    default = 8080
  }

variable "instance_type" {
    description = "The instance type to use for EC2 instances"
    default = "t2.micro"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_launch_configuration" "testlauncher" {
  name_prefix   = "terraform-lconf-"
  image_id     = "ami-0e86e20dae9224db8"
  instance_type = var.instance_type
  security_groups = [aws_security_group.testvm_sg.id]
  associate_public_ip_address = true
  key_name      = "testVM"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              echo "nohup busybox httpd -f -p ${var.server_port} &" >> /etc/rc.local
              chmod +x /etc/rc.local
              EOF

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group" "testvm_sg" {
    name = "testVM-terraform-security-group"
    description = "Security group for ASG instance"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "elb-sg" {
    name = "elb-security-group"
    description = "Security group for elb resource"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_autoscaling_group" "testASG" {
  launch_configuration = aws_launch_configuration.testlauncher.name
  availability_zones  = data.aws_availability_zones.available.names

  load_balancers   = [aws_elb.loadbal.name]
  health_check_type  = "ELB"
  min_size          = 1
  max_size          = 1
  desired_capacity  = 1

  tag {
    key                 = "Name"
    value               = "ASG Dev"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_elb" "loadbal" {
  name               = "test-ELB01"
  availability_zones = data.aws_availability_zones.available.names
  security_groups = [aws_security_group.elb-sg.id]


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


output "elb_dns_name" {
  value = aws_elb.loadbal.dns_name
  description = "The dns name of the elastic LB"
}


