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

output "elb_dns_name" {
  value = aws_elb.elastic_lb.dns_name
  description = "The dns name of the elastic LB"
}