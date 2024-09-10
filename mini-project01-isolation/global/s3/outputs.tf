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

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table for Terraform locks"
}
