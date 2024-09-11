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
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  multi_az = var.multi_az
}

resource "aws_db_subnet_group" "default" {
  name       = "db_layer_private_subnet_group"
  subnet_ids = var.db_private_subnet_ids
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "database_sg"
  description = "Allow inbound traffic from webserver"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from VPC"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_mysql"
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}
