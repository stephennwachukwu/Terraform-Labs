variable "region" {
  description = "VPC region for RDS Cross regional read replica" 
  type = string
  default = "us-west-2"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "delete_backup" {
  type = bool
  default = true
}

variable "public_cidrs" {
  type = list(any)
  default = ["10.0.1.0/24"]
}

variable "replica_rds_data_private_cidrs" {
  type = list(any)
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "nat_bool" {
  type = bool
  default = true
}

variable "availability_zone" {
  type = list(any)
  default = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]
}

variable "destination_cidr" {
  type = string
  default = "0.0.0.0/0"
}

# REPLICA RDS VARIABLES

variable "kms_user_name" {
  type = string
  default = "replica-kms-encryption-storage"
}

variable "kms_policy_name" {
  type = string
  default = "kms_policy"
}

variable "enable_customer_managed_key" {
  type = bool
  default = true
}

variable "deletion_windows" {
  type = number
  default = 30
}

variable "key_rotation" {
  type = bool
  default = false 
}

variable "max_allocated_storage" {
  type = number
  default = 100
}

variable "instance_class" {
  type = string
  default = "db.t3.micro" 
}

variable "storage_type" {
  type = string
  default = "gp2"
}

variable "storage_encrypted" {
  type = bool
  default = true
}

variable "db_accessibility" {
  type = bool
  default = false
}

variable "multi_az" {
  type = bool
  default = true
}

variable "db_port" {
  type = number
  default = 3306
}

variable "db_name" {
  type = string
  default = "replicaname"
}

variable "password"{
  type = string
  default = "yourpasswordreplica"
}

variable "username" {
  type = string
  default = "yourreplica"
}

variable "major_upgrade" {
  type = string
  default = false
}

variable "final_snapshot" {
    type = bool
    default = true
}

variable "retention_period" {
  type = number
  default = 7
}

variable "backup_window" {
  type = string
  default = "00:00-01:30"
}

variable "engine_version" {
  type = string
  default = "5.7"
}

variable "apply_db_modification_immediately" {
  type = bool
  default = false
}

variable "delete_automated_backups" {
  type = bool
  default = true
}

variable "replica_identifier" {
  type = string
  default = "cloudgen-replica-db-west"
}

variable "source_db_arn" {
  type = string
  default = ""     
  
  # Example of source_db_arn arn:aws:rds:us-east-1:123456789012:db:db-identifier
}