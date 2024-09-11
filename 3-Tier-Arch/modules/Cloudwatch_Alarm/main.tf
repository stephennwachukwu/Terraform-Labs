# CREATE SNS TOPIC
resource "aws_sns_topic" "cloudgen_compute_alarm" {
  count = var.enable_sns_topic ? 1 : 0
  name = "cloudwatch-cloudgen_compute_alarm"
}

# CREATE SNS SUBSCRIPTION FOR EMAIL NOTIFICATIONS
resource "aws_sns_topic_subscription" "sns_subscription"{
    count = var.enable_sns_subscription ? 1 : 0
    topic_arn = aws_sns_topic.cloudgen_compute_alarm[0].arn
    protocol = "email"
    endpoint = var.endpoint
}

# CLOUDWATCH METRIC ALARM FOR PRESENTATION LAYER
resource "aws_cloudwatch_metric_alarm" "presentation_layer" {
  count = var.enable_presentation_metrics ? 1 : 0
  alarm_name                = "presentation_layer_alarm"
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name
  namespace                 = var.namespace
  period                    = var.period
  statistic                 = var.statistics
  threshold                 = var.treshold
  alarm_description         = "This metric monitors ec2 cpu utilization"

  dimensions = {
    AutoScalingGroupName = var.presentation_layer_autoscaling_group_name
  }

  alarm_actions = [aws_sns_topic.cloudgen_compute_alarm[0].arn]
}

# CLOUDWATCH METRIC ALARM FOR APPLICATION LAYER
resource "aws_cloudwatch_metric_alarm" "application_layer" {
  count = var.enable_app_metrics ? 1 : 0
  alarm_name                = "application_layer_alarm"
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name
  namespace                 = var.namespace
  period                    = var.period
  statistic                 = var.statistics
  threshold                 = var.treshold
  alarm_description         = "This metric monitors ec2 cpu utilization"

  dimensions = {
    AutoScalingGroupName = var.application_layer_autoscaling_group_name
  }

  alarm_actions = [aws_sns_topic.cloudgen_compute_alarm[0].arn]
}

# CLOUDWATCH METRIC ALARM FOR DATA LAYER
resource "aws_cloudwatch_metric_alarm" "data_layer" {
  count = var.enable_db_metrics ? 1 : 0
  alarm_name                = "data_layer_alarm"
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name
  namespace                 = var.namespace
  period                    = var.period
  statistic                 = var.statistics
  threshold                 = var.data_treshold
  alarm_description         = "This metric monitors ec2 cpu utilization"

  dimensions = {
    InstanceId = var.data_layer_instance_id
  }

  alarm_actions = [aws_sns_topic.cloudgen_compute_alarm[0].arn]
}