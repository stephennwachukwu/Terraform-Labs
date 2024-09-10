output "vpc_id" {
  value = aws_vpc.main-net.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "ssh_http_security_group_id" {
  value = aws_security_group.ssh_http_access.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}
