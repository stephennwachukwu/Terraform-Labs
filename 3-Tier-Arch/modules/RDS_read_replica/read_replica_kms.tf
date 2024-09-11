# CREATE KMS KEY FOR CROSS-REGIONAL READ_REPLICA

resource "aws_kms_key" "rds_kms_key" {
  count = var.enable_customer_managed_key ? 1 : 0
  description = "kms key to enable customer managed encryption and decryption"
  deletion_window_in_days = var.deletion_windows
  enable_key_rotation = var.key_rotation
}

# CREATES KMS POLICY FOR CROSS-REGIONAL READ_REPLICA ENCRYPTION/DECRYPTION KEY

resource "aws_kms_key_policy" "rds_key_policy" {
  count = var.enable_customer_managed_key ? 1 : 0
  key_id = aws_kms_key.rds_kms_key[0].id
  policy = jsonencode({
    #Id = "example"
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }

        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}