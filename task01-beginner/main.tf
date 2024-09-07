provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "testvm" {
  ami     = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.testvm_sg.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags = {
    Name = "testVM-terraform"
    Environment = "Dev"
    }
}


resource "aws_security_group" "testvm_sg" {
    name = "testVM-terraform-security-group"
    description = "Security group for testvm instance"

    ingress{
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
  }
