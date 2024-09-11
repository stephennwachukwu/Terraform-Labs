# DYNAMO DB

resource "aws_dynamodb_table" "state_lock" {
  name           = "${var.state_lock}"
  billing_mode   = var.billing_mode
  hash_key       = var.hash_key
  read_capacity  = 50
  write_capacity = 50

  attribute {
    name = var.attribute_name_value
    type = "S"
  }

}