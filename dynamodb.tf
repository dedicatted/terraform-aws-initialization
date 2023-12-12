resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${var.dynamodb_name}-${random_string.suffix.result}"
  billing_mode   = var.dynamodb_billing_mode
  hash_key       = var.dynamodb_hash_key
  attribute {
    name = var.dynamodb_hash_key
    type = "S"
  }
}