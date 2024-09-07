provider "aws" {
  region = "us-east-1"
}


variable "server_port" { 
    description = "The intended server port for HTTP requests"
    default = 8080
  }

variable "ssh_key_name" {
  description = "The name of the SSH key pair to use for EC2 instances"
  type        = string
}

# State can be either: available, information, impaired, or unavailable
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_launch_configuration" "testlauncher" {
  name_prefix   = "terraform-lconf-"
  image_id     = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
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

resource "aws_autoscaling_group" "testASG" {
  name                 = "terraform-asg"
  launch_configuration = aws_launch_configuration.testlauncher.name
  availability_zones  = data.aws_availability_zones.available.names
  min_size             = 2
  max_size             = 3

  tag {
    key                 = "Environment"
    value               = "ASG Dev"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "asg_name" {
  value = aws_autoscaling_group.testASG.name
  description = "The name of the Auto Scaling Group"
}
