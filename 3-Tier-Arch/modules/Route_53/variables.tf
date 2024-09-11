# THE VALUES FOR THE LIST OF EMPTY VARIABLES ARE GENERATED IN THE ROOT DIRECTORY CLOUDGEN/main.tf !!!
# WARNING!!!! DO NOT TOUCH OR EDIT

variable "presentation_layer_lb_dns" {}
variable "presentation_layer_zone_id" {}

# END OF LIST OF EMPTY VARIABLES

variable "domain_name" {
  description = "stores desired domain name for the webserver"
  type = string
}

variable "record_type" {
  description = "The record type to use"
  type = string
  default = "A"
}

variable "evaluate_target_health" {
  type = bool
  default = true
}