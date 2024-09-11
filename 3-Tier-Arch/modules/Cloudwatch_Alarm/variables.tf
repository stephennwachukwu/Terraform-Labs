variable "presentation_layer_autoscaling_group_name" {}
variable "application_layer_autoscaling_group_name" {}
variable "data_layer_instance_id" {}

variable "endpoint" {
  description = "The End Point To Send Data TO"     # This attribute is required and the protocol varies!!!!
  type = string
}

variable "comparison_operator" {
  description = "(Required) The arithmetic operation to use when comparing the specified Statistic and Threshold"
  type = string
  default = "GreaterThanOrEqualToThreshold"
}

variable "evaluation_periods" {
  description = "(Required) The number of periods over which data is compared to the specified threshold"
  type = string
  default = "2"
}
variable "metric_name" {
  description = "(Optional) The name for the alarm's associated metric. See docs for supported metrics."
  type = string
  default = "CPUUtilization"
}
variable "namespace" {
  description = "(Optional) The namespace for the alarm's associated metric."
  type = string
  default = "AWS/EC2"
}
variable "period" {
  description = "(Optional) The period in seconds over which the specified statistic is applied"
  type = string
  default = "60"
}
variable "statistics" {
  description = "(Optional) The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  type = string
  default = "Average"
}
variable "treshold" {
  description = "(Optional) The value against which the specified statistic is compared. This parameter is required for alarms based on static thresholds, but should not be used for alarms based on anomaly detection models."
  type = string
  default = "80"
}
variable "data_treshold" {
  description = "(Optional) treshold fro data layer" # same usecase as "treshold variable above"
  type = string
  default = "90"
}

variable "enable_presentation_metrics" {
  description = "(Required) The conditional input to create cloudwatch metric alarm for presentation layer or not. true to enable cloudwatch,and false to disable presentation layer cloudwatch"
  type = bool
  default = true
}
variable "enable_app_metrics" {
  description = "(Required) The conditional input to create cloudwatch metric alarm for application layer or not. true to enable cloudwatch,and false to disable application layer cloudwatch"
  type = bool
  default = true
}
variable "enable_db_metrics" {
  description = "(Required) The conditional input to create cloudwatch metric alarm for data layer or not. true to enable cloudwatch,and false to disable data layer cloudwatch"
  type = bool
  default = true
}
variable "enable_sns_topic" {
  description = "(Required) The conditional input to create sns topic for cloudwatch metric alarm or not. true to enable,and false to disable" # Required If cloudwatch is enableds
  type = bool
  default = true
}
variable "enable_sns_subscription" {
  description = "(Required) The conditional input to create sns subscription for cloudwatch metric alarm or not. true to enable,and false to disable" # Required If cloudwatch is enableds
  type = bool
  default = true
}
