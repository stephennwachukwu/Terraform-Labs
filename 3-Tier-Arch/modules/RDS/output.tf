output "source_db_arn" {
  value = aws_db_instance.data_layer_rdb.arn
}

output "rds_instance_id" {
  value = aws_db_instance.data_layer_rdb.id
}
output "source_db_identifier" {
  value = aws_db_instance.data_layer_rdb.identifier
}