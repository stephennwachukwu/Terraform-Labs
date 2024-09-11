output "policy" {
  value = aws_kms_key_policy.rds_key_policy[0].policy
}
output "kms_key_id" {
  value = aws_kms_key.rds_kms_key[0].arn
}