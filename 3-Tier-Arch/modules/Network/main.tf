# VPC CONFIGURATON SECTION

resource "random_string" "random" {
  length           = 2
  special          = true
  override_special = "/@£$"
}

resource "aws_vpc" "cloudgen_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true


  tags = {
    "Name" = "cloudgen_vpc_${random_string.random.id}"
  }
}

# PUBLIC SUBNET FOR PRESENTATION LAYER

resource "aws_subnet" "presentation_layer_subnet" {
  count = length(var.public_cidrs)
  vpc_id = aws_vpc.cloudgen_vpc.id
  cidr_block = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone[count.index]


  tags = {
    Name = "presentation_layer_subnet_${count.index + 1}"
  }
}

# PRIVATE SUBNET FOR APPLICATION LAYER

resource "aws_subnet" "application_layer_subnet" {
  count = length(var.app_private_cidrs)
  vpc_id = aws_vpc.cloudgen_vpc.id
  cidr_block = var.app_private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone = var.availability_zone[count.index]


  tags = {
    Name = "application_layer_subnet_${count.index + 1}"
  }
}

# PRIVATE SUBNET FOR DATA LAYER

resource "aws_subnet" "data_layer_subnet" {
  count = length(var.data_private_cidrs)
  vpc_id = aws_vpc.cloudgen_vpc.id
  cidr_block = var.data_private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone = var.availability_zone[count.index]


  tags = {
    Name = "data_private_subnet_${count.index + 1}"
  }
}

# INTERNET GATEWAY

resource "aws_internet_gateway" "cloudgen_internet_gateway" {
  vpc_id = aws_vpc.cloudgen_vpc.id

  tags = {
    "Name" = "cloudgen_internet_gateway"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# NAT GATEWAY

resource "aws_eip" "nat_ip" {
  vpc = var.nat_bool

  tags = {
    "Name" = "nat_ip"
  }
}

resource "aws_nat_gateway" "cloudgen_nat_gateway" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.presentation_layer_subnet[0].id

  tags = {
    Name = "NAT gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.cloudgen_internet_gateway]
}

# PRESENTATION LAYER SUBNET ROUTING

resource "aws_route_table" "presentation_layer_route_table" {
  vpc_id = aws_vpc.cloudgen_vpc.id

  tags = {
    "Name" = "presentation_layer_route"
  }
}

resource "aws_route_table_association" "presentation_layer_subnet_association" {
  count = length(var.public_cidrs)
  subnet_id      = "${aws_subnet.presentation_layer_subnet.*.id[count.index]}"
  route_table_id = aws_route_table.presentation_layer_route_table.id
}

resource "aws_route" "presentation_layer_route" {
 route_table_id = aws_route_table.presentation_layer_route_table.id
 destination_cidr_block = var.destination_cidr
 gateway_id = aws_internet_gateway.cloudgen_internet_gateway.id 
}

# APPLICATION LAYER LAYER SUBNET ROUTING

resource "aws_route_table" "application_layer_route_table" {
  vpc_id = aws_vpc.cloudgen_vpc.id

  tags = {
    "Name" = "application_layer_route"
  }
}

resource "aws_route_table_association" "application_layer_subnet_association" {
  count = length(var.app_private_cidrs)
  subnet_id      = "${aws_subnet.application_layer_subnet.*.id[count.index]}"
  route_table_id = aws_route_table.application_layer_route_table.id
}

resource "aws_route" "application_layer_route" {
 route_table_id = aws_route_table.application_layer_route_table.id
 destination_cidr_block = var.destination_cidr
 nat_gateway_id = aws_nat_gateway.cloudgen_nat_gateway.id
}

# DATA LAYER SUBNET ROUTING

resource "aws_route_table" "data_layer_route_table" {
  vpc_id = aws_vpc.cloudgen_vpc.id

  tags = {
    "Name" = "data_layer_route"
  }
}

resource "aws_route_table_association" "data_layer_subnet_association" {
  count = length(var.data_private_cidrs)
  subnet_id      = "${aws_subnet.data_layer_subnet.*.id[count.index]}"
  route_table_id = aws_route_table.data_layer_route_table.id
}


resource "aws_route" "data_layer_route" {
 route_table_id = aws_route_table.data_layer_route_table.id
 destination_cidr_block = var.destination_cidr
 nat_gateway_id = aws_nat_gateway.cloudgen_nat_gateway.id
}

# PRESENTATION LAYER LOAD-BALANCER SECURITY GROUP 

resource "aws_security_group" "presentation_layer_lb_sg" {
  name = "presentation_layer_lb_sg"
  description = "presentation layer security group"
  vpc_id = aws_vpc.cloudgen_vpc.id

  ingress {
    description = "Allows inbound HTTP traffic from the internet"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.destination_cidr]
  }
  egress {
    description = "Allows outbound traffic to the internet"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.destination_cidr]
  }
}

# PRESENTATION LAYER AUTOSCALING GROUP SECURITY GROUP

resource "aws_security_group" "presentation_layer_sg" {
  name = var.presentation_layer_sg
  description = "security group for presentation layer instances"
  vpc_id = aws_vpc.cloudgen_vpc.id  

  ingress {
    description = "Allows HTTP Traffic From Presentation Layer LoadBalancer"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.presentation_layer_lb_sg.id]
  }
  egress {
    description = "Allows All Outbound Traffic To Application Layer LoadBalancer"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.destination_cidr]
  }
}


# APPLICATION LOAD BALANCER SECURITY GROUP

resource "aws_security_group" "alb_security_group" {
    name = "application-layer-lb-sg"
    description = "security group for application load balancer"
    vpc_id = aws_vpc.cloudgen_vpc.id

    ingress {
      description = "Allows Inbound Traffic From Presentation Layer Instances"
      from_port = 80
      to_port = 80
      protocol = "tcp"
      security_groups = [aws_security_group.presentation_layer_sg.id]
    }

    egress {
      description = "Alllows HTTP Traffic To The Application Layer Autoscaling Group"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [var.destination_cidr]
    }
}

# APPLICATION LAYER AUTOSCALING SECURITY GROUP

resource "aws_security_group" "application_layer_sg" {
  name = var.application_layer_sg
  description = "security group for application layer instances"
  vpc_id = aws_vpc.cloudgen_vpc.id

  ingress {
    description = "Allows Inbound Traffic From The Application Layer Load Balancer"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }
  egress {
    description = "Allows Outbound Traffic From The Data Layer RDS Instances"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.destination_cidr]
  }  
}

# DATA LAYER SECURITY GROUP

resource "aws_security_group" "data_layer_sg" {
  name = var.data_layer_sg
  description = "security group for data layer instances"
  vpc_id = aws_vpc.cloudgen_vpc.id

  ingress {
    description = "Allows Traffic From The Application Layer Autoscaling Group"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.application_layer_sg.id]
  }  
  egress {
    description = "Allows Traffic Out Of The RDS Instances"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.destination_cidr]
  }
}
