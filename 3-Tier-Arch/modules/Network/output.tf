output "vpc_id" {
    value = aws_vpc.cloudgen_vpc.id
}

output "presentation_layer_subnet" {
  value = aws_subnet.presentation_layer_subnet.*.id
}

output "application_layer_subnet" {
  value = aws_subnet.application_layer_subnet.*.id
}
output "data_layer_subnet" {
  value = aws_subnet.data_layer_subnet.*.id
}

output "presentation_layer_lb_sg" {
  value = aws_security_group.alb_security_group.id
}

output "alb_sg" {
  value = aws_security_group.alb_security_group.id
}

output "presentation_layer_sg" {
  value = aws_security_group.presentation_layer_sg.id
}
output "application_layer_sg" {
  value = aws_security_group.application_layer_sg.id
}
output "data_layer_sg" {
  value = aws_security_group.data_layer_sg.id
}

output "public_cidrs" {
  value = var.public_cidrs
}
output "app_private_cidrs" {
  value = var.app_private_cidrs
}
output "data_private_cidrs" {
  value = var.app_private_cidrs
}
