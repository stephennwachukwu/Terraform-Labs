output "presentation_layer_lb_arn" {
  value = aws_lb.presentation_layer_lb.arn
}
output "presentation_layer_lb_dns" {
  value = aws_lb.presentation_layer_lb.dns_name
}
output "presentation_layer_lb_zone_id" {
  value = aws_lb.presentation_layer_lb.zone_id
}

output "presentation_layer_tg_arn" {
  value = aws_lb_target_group.presentation_layer_lb_tg.arn
}

output "application_layer_tg_arn" {
  value = aws_lb_target_group.application_layer_lb_tg.arn
}