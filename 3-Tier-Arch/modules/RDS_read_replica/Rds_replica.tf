# CREATES SUBNET GROUP FOR CROSS-REGIONAL READ_REPLICA RELATIONAL DATABASE INSTANCE 

resource "aws_db_subnet_group" "replica_rds_subnet_group" {
  name = "replica_data_layer_subnet_group"
  subnet_ids = aws_subnet.replica_rds_data_layer_subnet.*.id
}

# CREATES READ_REPLICA FOR CROSS-REGIONAL RELATIONAL DATABASE INSTANCE

resource "aws_db_instance" "data_layer_rdb" {
  replicate_source_db = var.source_db_arn
  db_subnet_group_name = aws_db_subnet_group.replica_rds_subnet_group.name
  identifier = var.replica_identifier
  publicly_accessible = var.db_accessibility
  max_allocated_storage = var.max_allocated_storage
  engine_version = var.engine_version
  instance_class = var.instance_class
  storage_type = var.storage_type
  storage_encrypted = var.storage_encrypted
  multi_az = var.multi_az
  kms_key_id = aws_kms_key.rds_kms_key[0].arn
  port = var.db_port
  skip_final_snapshot = var.final_snapshot
  apply_immediately = var.apply_db_modification_immediately
  backup_retention_period = var.retention_period 
  backup_window = var.backup_window  
  delete_automated_backups = var.delete_backup
}