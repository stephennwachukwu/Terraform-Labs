# CREATE RMS KEY FOR ENCRYPTION AND DECRYPTION OF STORAGE ENCRYPTED RDS INSTANCES !!!!
# THE KMS AND POLICY IS NOT REQUIRED IF STORAGE ENRYPTION OF THE RDS INSTANCES IS SET TO FALSE, HENCE SET THE enable_customer_managed_key value to false to disable kms key creation !!!!!!!!!!!

resource "aws_kms_key" "rds_kms_key" {
  count = var.enable_customer_managed_key ? 1 : 0
  description = "kms key to enable customer managed encryption and decryption"
  deletion_window_in_days = var.deletion_windows
  enable_key_rotation = var.key_rotation
  is_enabled = var.is_enabled
  multi_region = var.multi_region
  customer_master_key_spec = var.customer_master_key_spec
}

# CREATES POLICY TO ENABLE ENCRYPTION/DECRYPTION FOR THE KMS KEY !!!!
# AN IAM USER CAN BE CREATED AND ATTCHED TO THIS POLICY, ELSE, THE ACCESS TO THIS KEY IS GRANTED TO THE ROOT USER OF THIS ACCOUNT !!!!

# NOTE :- Every AWS Key Management Service (KMS) key must have a key policy. If you do not provide a custom key policy during creation, AWS will assign a default key policy to the KMS key. This default key policy grants all entities within the owning AWS account unrestricted access to perform any KMS operation using the key. Essentially, the default key policy delegates all access control decisions to IAM policies and KMS grants. To ensure proper security and access control, it is recommended to define a custom key policy that explicitly specifies the necessary permissions for individual entities and operations associated with the KMS key. This approach follows the principle of least privilege and helps secure sensitive data.

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



