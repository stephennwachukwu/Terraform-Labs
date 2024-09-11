output "http_ssh_sg_id" {
  description = "The ID of the webserver's security group"
  value       = aws_instance.web_server.vpc_security_group_ids
}

output "public_ip" {
   value = aws_instance.web_server.public_ip
}

output "webserver_instance_id" {
  description = "The instance ID of the webserver"
  value       = aws_instance.web_server.id
}
