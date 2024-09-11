# THE VALUES FOR THE LIST OF EMPTY VARIABLES ARE GENERATED IN THE ROOT DIRECTORY CLOUDGEN/main.tf !!!
# WARNING!!!! DO NOT TOUCH OR EDIT

variable "presentation_layer_sg" {}
variable "application_layer_sg" {}
variable "presentation_layer_subnets" {}
variable "application_layer_subnets" {}
variable "presentation_layer_tg_arn" {}
variable "application_layer_tg_arn" {}
variable "public_cidrs" {
  description = "(Required)  used as an iterator to create multiple resources or attach attributes to resources in the presentation subnet for the presentation layer"
  type = list(any)
}
variable "app_private_cidrs" {
  description = "(Required)  used as an iterator to create multiple resources or attach attributes to resources in the private subnet for the application layer"
  type = list(any)
}
variable "key_name" {
  description = "(Required) Key name for EC2 Instances  e.g : keyname.pem"
  type = string
  default = ""
}

# END OF EMPTY VARIABLES !!!!!!!!!

variable "frontend_server_instance_type" {
  description = "(Optional) The type of the instance. If present then instance_requirements cannot be present."
  type = string
  default = "t2.micro"
}

variable "application_server_instance_type" {
  description = "(Optional) The type of the instance. If present then instance_requirements cannot be present."
  type = string
  default = "t2.micro"
}
variable "associate_public_ip" {
  description = "(Optional) Associate a public ip address with the network interface. Boolean value, can be left  unset." #  Defaults to true for the presentation layer subnets !!
  type = bool
  default = true

}
variable "app_associate_public_ip" {
  description = "(Optional) Associate a public ip address with the network interface. Boolean value, can be left  unset." #  Defaults to false for the application layer subnets !!
  type = bool
  default = false
}

variable "enable_monitoring" {
  description = "(Optional) The monitoring option for the instance"
  type = bool
  default = true
}