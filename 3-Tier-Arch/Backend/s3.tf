# This is terraform module that creates and manage S3 bucket and a dynamo db to store state
# Files remotely and enable remote state locking. 

resource "aws_s3_bucket" "cloudgen-s3" {
  bucket = "multilayer-bucket"

  versioning {
    enabled = var.versioning_enabled
  }

   server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
      }
    }
  }
}
