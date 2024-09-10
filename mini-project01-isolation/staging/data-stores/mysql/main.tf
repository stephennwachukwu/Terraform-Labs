resource "aws_db_instance" "mysqldb" {
  allocated_storage    = 10
  db_name              = "${var.db_name}"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}


