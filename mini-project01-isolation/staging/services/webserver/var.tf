variable "subnet_id" {
  description = "The ID of the subnet to launch the instance in"
  type        = string
}

variable "http_ssh_sg_id" {
  description = "A list of security group IDs to associate with the instance"
  type        = list(string)
}

variable "ssh_public_key" {
  description = "The public key for SSH access"
  type        = string
  sensitive   = true
}

variable "key_name" {
  description = "The name of the key pair"
  type        = string
}

variable "user_password" {
  description = "Password for the indiehacker"
  type        = string
  sensitive   = true
}

variable "db_host" {
  description = "The host of the database"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default = "staging_db"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}
