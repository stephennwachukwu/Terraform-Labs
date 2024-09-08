provider "aws" {
  region = "us-east-1"
}

variable "server_port" { 
    description = "The intended server port for HTTP requests"
    default = 80
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

resource "aws_vpc" "main-net" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-net"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main-net.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main-net.id
  cidr_block = "10.0.2.0/24"


  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-net.id
  
  tags = {
    Name = "main-net_igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main-net.id

   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

   tags = {
    Name = "Public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ssh_http_access" {
    name_prefix = "TestVM_http_ssh_access"
    vpc_id      =  aws_vpc.main-net.id
    description = "Security group for SSH and HTTP access"

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

resource "aws_instance" "web_server" {
  ami     = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  subnet_id	= aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ssh_http_access.id]
  key_name      = aws_key_pair.deployer.key_name

  depends_on = [aws_internet_gateway.igw]

  user_data = <<-EOF
        #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2
              echo "<html><body><h1>Welcome to my website!</h1></body></html>" > /var/www/html/index.html
              sudo systemctl restart apache2

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
    Name = "webserver-terraform"
    Environment = "Dev"
    }
}

resource "aws_eip" "eip" {
  instance = aws_instance.web_server.id


  tags = {
    Name = "test-eip01"
  }
}

output "public_ip" {
   value = aws_instance.web_server.public_ip
}
