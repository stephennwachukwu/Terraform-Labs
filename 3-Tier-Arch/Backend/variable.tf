variable "state_lock" {
  description = "DynamoDB table name for terraform lock."
  type        = string
  default = "state_lock"
}

variable "sse_algorithm" {
  description = "algorithm key for sse_algorithm"
  type = string
  default = "AES256"
}

variable "hash_key" {
  description = "hashkey for dynamo db table"
  type = string
  default = "LockID"
}

variable "attribute_name_value" {
  description = "attribute value for dynamo db table"
  type = string
  default = "LockID"
}

variable "billing_mode" {
  description = "attribute value for dynamo db table"
  type = string
  default = "PROVISIONED"
}
variable "versioning_enabled" {
  type = bool
  default = false
}
