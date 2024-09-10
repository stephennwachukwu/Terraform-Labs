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
