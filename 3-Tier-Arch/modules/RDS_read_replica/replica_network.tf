# CROSS-REGIONAL READ_REPLICA VPC SECTION

resource "random_string" "random" {
  length           = 2
  special          = true
  override_special = "/@£$"
}

resource "aws_vpc" "cloudgen_replica_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true


  tags = {
    "Name" = "cloudgen_replica_vpc_${random_string.random.id}"
  }
}

# PUBLIC SUBNET FOR CROSS-REGIONAL READ_REPLICA RDS PRESENTATION LAYER

resource "aws_subnet" "replica_rds_presentation_layer_subnet" {
  count = length(var.public_cidrs)
  vpc_id = aws_vpc.cloudgen_replica_vpc.id
  cidr_block = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone[count.index]


  tags = {
    Name = "replica_rds_presentation_layer_subnet_${count.index + 1}"
  }
}

# PRIVATE SUBNET FOR CROSS-REGIONAL READ_REPLICA RDS DATA LAYER

resource "aws_subnet" "replica_rds_data_layer_subnet" {
  count = length(var.replica_rds_data_private_cidrs)
  vpc_id = aws_vpc.cloudgen_replica_vpc.id
  cidr_block = var.replica_rds_data_private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone = var.availability_zone[count.index]


  tags = {
    Name = "replica_data_private_subnet_${count.index + 1}"
  }
}

# INTERNET GATEWAY FOR CROSS-REGIONAL READ_REPLICA RDS

resource "aws_internet_gateway" "cloudgen_read_replica_internet_gateway" {
  vpc_id = aws_vpc.cloudgen_replica_vpc.id

  tags = {
    "Name" = "cloudgen_read_replica_internet_gateway"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# NAT GATEWAY FOR CROSS-REGIONAL READ_REPLICA

resource "aws_eip" "nat_ip" {
  vpc = var.nat_bool

  tags = {
    "Name" = "nat_ip"
  }
}

resource "aws_nat_gateway" "cloudgen_replica__nat_gateway" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.replica_rds_presentation_layer_subnet[0].id

  tags = {
    Name = "NAT gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.cloudgen_read_replica_internet_gateway]
}

# PRESENTATION LAYER SUBNET ROUTING FOR CROSS-REGIONAL READ_REPLICA RDS

resource "aws_route_table" "replica_presentation_layer_route_table" {
  vpc_id = aws_vpc.cloudgen_replica_vpc.id

  tags = {
    "Name" = "replica_presentation_layer_route"
  }
}

resource "aws_route_table_association" "replica_presentation_layer_subnet_association" {
  count = length(var.public_cidrs)
  subnet_id      = "${aws_subnet.replica_rds_presentation_layer_subnet.*.id[count.index]}"
  route_table_id = aws_route_table.replica_presentation_layer_route_table.id
}

resource "aws_route" "replica_presentation_layer_route" {
 route_table_id = aws_route_table.replica_presentation_layer_route_table.id
 destination_cidr_block = var.destination_cidr
 gateway_id = aws_internet_gateway.cloudgen_read_replica_internet_gateway.id 
}

# DATA LAYER SUBNET ROUTING

resource "aws_route_table" "replica_data_layer_route_table" {
  vpc_id = aws_vpc.cloudgen_replica_vpc.id

  tags = {
    "Name" = "replica_data_layer_route"
  }
}

resource "aws_route_table_association" "replica_data_layer_subnet_association" {
  count = length(var.replica_rds_data_private_cidrs)
  subnet_id      = "${aws_subnet.replica_rds_data_layer_subnet.*.id[count.index]}"
  route_table_id = aws_route_table.replica_data_layer_route_table.id
}


resource "aws_route" "data_layer_route" {
 route_table_id = aws_route_table.replica_data_layer_route_table.id
 destination_cidr_block = var.destination_cidr
 nat_gateway_id = aws_nat_gateway.cloudgen_replica__nat_gateway.id
}