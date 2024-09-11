# THE VALUES FOR THE LIST OF EMPTY VARIABLES ARE GENERATED IN THE ROOT DIRECTORY CLOUDGEN/main.tf !!!
# WARNING!!!! DO NOT TOUCH OR EDIT

variable "vpc_id"{}
variable "db_private_subnet_id" {}
variable "data_layer_sg" {}
variable "kms_key_id" {
  description = "(Optional) The ARN for the KMS encryption key" # If creating an encrypted replica, set this to the destination KMS ARN

  type = string
}

# END OF EMPTY VARIABLES !!!!!!!!!

##########################################################
         # RDS INSTANCES VARIABLES
##########################################################

variable "username" {
  description = "(Required unless a snapshot_identifier is provided) Username for the master DB user" # If creating an encrypted replica, set this to the destination KMS ARN

  type = string
  default = "enteryourusernameplease"
}

variable "password" {
  description = "(Required unless manage_master_user_password is set to true or unless a snapshot_identifier is set)Password for the master DB user"

  type = string
  default = "enteryourpassword"
}

variable "db_name" {
  description = "(Required) The name of the database to create when the DB instance is created"

  type = string 
  default = "cloudgendb"
}

variable "allocated_storage" {
  description = "(Required) The allocated storage in gibibytes"

  type = number
  default = 50
}

variable "max_allocated_storage" {
  description = "(Optional) When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance"

  type = number
  default = 100
}

variable "instance_class" {
  description = "(Required) The instance type of the RDS instance"

  type = string
  default = "db.t3.micro" 
}

variable "storage_type" {
  description = "(Optional) One of standard (magnetic), gp2 (general purpose SSD), gp3 (general purpose SSD that needs iops independently) or io1 (provisioned IOPS SSD)"

  type = string
  default = "gp2"
}

variable "storage_encrypted" {
  description = "(Optional) Specifies whether the DB instance is encrypted" # Note :- if you are creating a cross-region read replica this field is ignored and you should instead declare kms_key_id with a valid ARN !!!!!!

  type = bool
  default = true
}

variable "db_accessibility" {
  description = "(Optional) Bool to control if instance is publicly accessible"

  type = bool
  default = false
}

variable "multi_az" {
  description = "(Optional) Specifies if the RDS instance is multi-AZ"

  type = bool
  default = true
}

variable "db_port" {
  description = "The port on which the DB accepts connections"

  type = number
  default = 3306
}

variable "major_upgrade" {
  description = "(Optional) Indicates that major version upgrades are allowed"

  type = string
  default = false
}

variable "final_snapshot" {
    description = "(Optional) Determines whether a final DB snapshot is created before the DB instance is deleted"

    type = bool
    default = true 
}

variable "retention_period" {
  description = "(Optional) The days to retain backups for. Must be between 0 and 35"

  type = number
  default = 7
}

variable "backup_window" {
  description = "(Optional) The daily time range (in UTC) during which automated backups are created if they are enabled"

  type = string
  default = "03:00-04:30"
}

variable "engine_version" {
  description = "(Optional) The engine version to use"

  type = string
  default = "5.7"
}

variable "rds_identifier" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"  # Required if restore_to_point_in_time is specified

  type = string
  default = "cloudgen-main-db"
}

variable "engine" {
  description = "The database engine to use"

  type = string
  default = "mysql"
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"

  type = string
  default = "aws_db_subnet_group.rds_subnet_group.id"
}

variable "apply_db_modification_immediately" {
  description = "(Optional) Specifies whether any database modifications are applied immediately, or during the next maintenance window"

  type = bool
  default = false
}

variable "delete_automated_backups" {
  description = "(Optional) Specifies whether to remove automated backups immediately after the DB instance is deleted"

  type = bool
  default = true
}

variable "minor_upgrade" {
  description = "(Optional) Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"

  type = bool
  default = true
}
