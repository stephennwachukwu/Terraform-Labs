variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "staging_db"
}

variable "db_username" {
  description = "The username of the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password of the database"
  type        = string
  sensitive   = true
}

variable "vpc_id"{}
variable "db_private_subnet_ids" {
  type = list(string)
}

variable "multi_az" {
  description = "(Optional) Specifies if the RDS instance is multi-AZ"
  type = bool
  default = true
}
