resource "aws_instance" "web_server" {
  ami     = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  subnet_id	= var.subnet_id
  vpc_security_group_ids = [var.http_ssh_sg_id]
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
