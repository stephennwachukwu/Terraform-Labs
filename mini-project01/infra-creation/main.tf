#provider "aws" {
#  region = "us-east-1"
#  endpoints {
#    s3 = "https://s3.us-east-1.amazonaws.com"
#  }
#}

variable "server_port" { 
    description = "The intended server port for HTTP requests"
    default = 80
  }

variable "ssh_port" {
  description = "for SSH into the server"
  default = 22
}

variable "jenkins_port" {
  description = "for jenkin"
  default = 8080
}


variable "ssh_public_key" {
  description = "The public key for SSH access"
  type        = string
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.ssh_public_key
}

variable "user_password" {
  description = "Password for the indiehacker"
  type        = string
  sensitive   = true
}

resource "aws_vpc" "main-net" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-net"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main-net.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main-net.id
  cidr_block = "10.0.2.0/24"


  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-net.id
  
  tags = {
    Name = "main-net_igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main-net.id

   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

   tags = {
    Name = "Public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ssh_http_access" {
    name_prefix = "TestVM_http_ssh_access"
    vpc_id      =  aws_vpc.main-net.id
    description = "Security group for SSH and HTTP access"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.jenkins_port
    to_port     = var.jenkins_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami     = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  subnet_id	= aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ssh_http_access.id]
  key_name      = aws_key_pair.deployer.key_name

  depends_on = [aws_internet_gateway.igw]

  user_data = <<-EOF
        #!/bin/bash
              useradd -m -s /bin/bash indiehacker
              echo "indiehacker:${var.user_password}" | chpasswd
              echo "indiehacker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

              mkdir -p /home/indiehacker/.ssh
              echo "${var.ssh_public_key}" >> /home/indiehacker/.ssh/authorized_keys
              chown -R indiehacker:indiehacker /home/indiehacker/.ssh
              chmod 700 /home/indiehacker/.ssh
              chmod 600 /home/indiehacker/.ssh/authorized_keys

              # Allow password authentication (optional, remove if you want key-based auth only)
              sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              systemctl restart sshd

              sudo apt install openjdk-11-jdk -y
              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]  https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt update
              sudo apt install jenkins
              sudo systemctl start jenkins
              sudo ufw allow ${var.jenkins_port}
              sudo ufw allow ssh
              sudo ufw enable
              touch jenks-pass
              sudo cat /var/lib/jenkins/secrets/initialAdminPassword > jenks-pass

              sudo usermod -a -G docker $USER
              sudo usermod -a -G docker jenkins
              EOF

  tags = {
    Name = "webserver-terraform"
    Environment = "Dev"
    }
}

resource "aws_eip" "eip" {
  instance = aws_instance.web_server.id


  tags = {
    Name = "test-eip01"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket-${random_id.bucket_suffix.hex}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 8
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_policy" "terraform_state_access" {
  name        = "terraform-state-access-policy"
  path        = "/"
  description = "IAM policy for accessing the S3 terraform state bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListBucketMultipartUploads"
        ]
        Resource = aws_s3_bucket.terraform_state.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ]
        Resource = "${aws_s3_bucket.terraform_state.arn}/*"
      }
    ]
  })
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table for Terraform locks"
}

output "terraform_state_bucket_name" {
  value       = aws_s3_bucket.terraform_state.id
  description = "The name of the S3 bucket for Terraform state"
}

output "s3_bucket_arn" {
   value = aws_s3_bucket.terraform_state.arn
}

output "iam_policy_arn" {
  value       = aws_iam_policy.terraform_state_access.arn
  description = "The ARN of the IAM policy for accessing the Terraform state bucket"
}

output "public_ip" {
   value = aws_instance.web_server.public_ip
}
