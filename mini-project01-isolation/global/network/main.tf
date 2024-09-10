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

resource "aws_subnet" "db_private_subnet" {
  count = length(var.data_private_cidrs)
  vpc_id     = aws_vpc.main-net.id
  cidr_block = var.data_private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone = var.availability_zone[count.index]
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

  ingress {
    from_port   = var.jenkins_port
    to_port     = var.jenkins_port
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

