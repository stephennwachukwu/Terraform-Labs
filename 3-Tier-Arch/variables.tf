variable "region" {
  description = "Vpc Region"
  type        = string
  default     = "us-east-1"
}
variable "replica_region" {
  description = "Replica Region"
  type        = string
  default     = "us-west-2"
}

variable "key_name" {
  type    = string
  default = "terraform"
}

variable "db_name" {
  type = string
  default = "enterdbname"
}
variable "username" {
  type = string
  default = "enteryourusername"
}
variable "password" {
  type = string
  default = "enteryourpassword6754645"   #make sure your password contains uppercase,lowercase,numerics & symbols!!!!
}