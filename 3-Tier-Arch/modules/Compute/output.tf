output "presentation_layer_asg_id" {
  value = aws_autoscaling_group.presentation_layer_autoscaling_group.id
}

output "application_layer_asg_id" {
  value = aws_autoscaling_group.application_layer_autoscaling_group.id
}

output "presentation_layer_autoscaling_group_name" {
  value = aws_autoscaling_group.presentation_layer_autoscaling_group.name
}

output "application_layer_autoscaling_group_name" {
  value = aws_autoscaling_group.application_layer_autoscaling_group.name
}