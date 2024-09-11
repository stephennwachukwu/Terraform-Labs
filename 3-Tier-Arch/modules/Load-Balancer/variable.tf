# THE VALUES FOR THE LIST OF EMPTY VARIABLES ARE GENERATED IN THE ROOT DIRECTORY CLOUDGEN/main.tf !!!
# WARNING!!!! DO NOT TOUCH OR EDIT

variable "presentation_layer_lb_sg" {}
variable "alb_sg" {}
variable "presentation_layer_subnet" {}
variable "application_layer_subnet" {}
variable "vpc_id" {}
variable "public_cidrs" {}
variable "app_private_cidrs" {}
variable "presentation_layer_asg_id" {}
variable "application_layer_asg_id" {}

# END OF EMPTY VARIABLES !!!!!!!!!

##########################################################
           # LOAD BALANCER VARIABLES
##########################################################

variable "lb_name" {
  description = "Unique name for load balancer"  # The resource name must be unique, contain only alphanumeric characters or hyphens, and not start or end with a hyphen, with a maximum of 32 characters allowed.

  type = string
  default = "presentation-layer-lb"
}

variable "app-lb-name" {
  description = "Unique name for load balancer"  # The resource name must be unique, contain only alphanumeric characters or hyphens, and not start or end with a hyphen, with a maximum of 32 characters allowed.

  type = string
  default = "application_layer_lb"
}

variable "lb_type" {
  description = "LoadBalancer type to be created !" #  Possible values are application, gateway, or network
  type = string
  default = "application"
}

variable "listener_port" {
  default = 80
}

variable "app_listener_port" {
  default = 80
}

##########################################################
        # LOAD BALANCER TARGET GROUP VARIABLES
##########################################################

variable "tg_port" {
  description = "Port on which targets receive traffic, unless overridden when registering a specific target. Required when target_type is instance, ip or alb"

  default = 80
}

variable "listener_protocol" {
  description = "(Required) Protocol to use for routing traffic from the internet. Should be one of GENEVE, HTTP, HTTPS, TCP, TCP_UDP, TLS, or UDP"

  type = string
  default = "HTTP"
}

variable "tg_protocol" {
  description = "(Required) Protocol to use for routing traffic to the targets. Should be one of GENEVE, HTTP, HTTPS, TCP, TCP_UDP, TLS, or UDP"

  type = string
  default = "HTTP"
}

variable "lb_tg_name" {
  type = string
  default = "presentation-layer-lb-tg"
}

variable "health_check_interval" {
  description = "Approximate amount of time, in seconds, between health checks of an individual target"

  default = 15
}

variable "timeout" {
  description = "Amount of time, in seconds, during which no response from a target means a failed health check"
  
  default = 5
}

variable "unhealthy_threshold" {
  description = "Number of consecutive health check failures required before considering a target unhealthy"
  default = 5
}

variable "health_check_matcher" {
  description = "Response codes to use when checking for a healthy responses from a target"

  type = string
  default = "200"
}

variable "app_lb_name" {
  description = "application loadbalancer name" # The resource name must be unique, contain only alphanumeric characters or hyphens, and not start or end with a hyphen, with a maximum of 32 characters allowed

  type = string
  default = "application-load-balancer"
}

variable "app_lb_tg_name" {
  description = "application loadbalancer target name" # The resource name must be unique, contain only alphanumeric characters or hyphens, and not start or end with a hyphen, with a maximum of 32 characters allowed

  type = string
  default = "application-lb-tg"
}

variable "app_tg_port" {
  description = "Port on which targets receive traffic, unless overridden when registering a specific target"
  
  default = 80
}
