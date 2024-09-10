
output "db_instance_endpoint" {
  description = "The connection endpoint for the database"
  value       = aws_db_instance.mysqldb.endpoint
}

output "db_instance_name" {
  description = "The name of the database"
  value       = aws_db_instance.mysqldb.db_name
}
