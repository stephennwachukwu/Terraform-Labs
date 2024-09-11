variable "vpc_cidr" {
  description = "(Required) vpc cidr"
  
  type = string
  default = "10.0.0.0/16"
}

variable "public_cidrs" {
  description = "(Required)  used as an iterator to create multiple resources or attach attributes to resources in the presentation subnet for the presentation layer"

  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_private_cidrs" {
  description = "(Required)  used as an iterator to create multiple resources or attach attributes to resources in the application subnet for the application layer"

  type = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "data_private_cidrs" {
  description = "(Required)  used as an iterator to create multiple resources or attach attributes to resources in the data subnet for the data layer"

  type = list(string)
  default = ["10.0.5.0/24", "10.0.6.0/24"]
}


variable "availability_zone" {
  description = "Iterator to places subnets in different availablity zones to enable high availabilty of resources"

  type = list(any)
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
}

variable "destination_cidr" {
  description = "destination cidr, usually 0.0.0.0/0 which means everywhere on the internet"

  type = string
  default = "0.0.0.0/0"
}

variable "registered_ip" {
  description = "Used to accept ssh connection from a bastion host or administrative machine ip" # default is 0.0.0.0/0 ifip is not specified

  type = string
  default = "0.0.0.0/0"
}

variable "presentation_layer_sg" {
  description = "presentation layer security group name"

  type = string
  default = "presentation_layer_sg"
}

variable "application_layer_sg" {
  description = "application layer security group name"

  type = string
  default = "application_layer_sg"
}

variable "data_layer_sg" {
  description = "data layer security group name"

  type = string
  default = "data_layer_sg"
}

variable "nat_bool" {
  type = bool
  default = true
}