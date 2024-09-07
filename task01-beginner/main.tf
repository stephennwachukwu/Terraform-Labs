provider "aws" {
  region = "us-east-1"
}


variable "server_port" { 
    description = "The intended server port for HTTP requests"
    default = 8080
  }

variable "ssh_port" {
  description = "for SSH into the server"
  default = 22
}

variable "ssh_public_key" {
  description = "The public key for SSH access"
  type        = string
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.ssh_public_key
}

variable "user_password" {
  description = "Password for the indiehacker"
  type        = string
  sensitive   = true
}

resource "aws_instance" "testvm" {
  ami     = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.testvm_sg.id]
  key_name      = aws_key_pair.deployer.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              echo "nohup busybox httpd -f -p ${var.server_port} &" >> /etc/rc.local
              chmod +x /etc/rc.local

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
              EOF

  tags = {
    Name = "testVM-terraform"
    Environment = "Dev"
    }
}


resource "aws_security_group" "testvm_sg" {
    name = "testVM-terraform-security-group"
    description = "Security group for testvm instance"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
   value = aws_instance.testvm.public_ip
}

output "public_dns" {
  value = aws_instance.testvm.public_dns
}

