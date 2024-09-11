resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "data_layer_subnet_group"
  subnet_ids = "${var.db_private_subnet_id}"
}

/* data "aws_kms_key" "by_id" {
  key_id = var.kms_key_id
} */

resource "aws_db_instance" "data_layer_rdb" {
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  publicly_accessible = var.db_accessibility
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  engine_version = var.engine_version
  instance_class = var.instance_class
  storage_type = var.storage_type
  identifier = var.rds_identifier
  storage_encrypted = var.storage_encrypted
  engine = var.engine
  multi_az = var.multi_az
  db_name = var.db_name 
  username = var.username
  password = var.password
  kms_key_id = var.kms_key_id
  port = var.db_port
  skip_final_snapshot = var.final_snapshot
  vpc_security_group_ids = [var.data_layer_sg]
  allow_major_version_upgrade = var.major_upgrade 
  auto_minor_version_upgrade = var.minor_upgrade
  apply_immediately = var.apply_db_modification_immediately
  backup_retention_period = var.retention_period 
  backup_window = var.backup_window  
  delete_automated_backups = var.delete_automated_backups
}