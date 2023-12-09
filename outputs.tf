output "backend_configuration" {
  value = <<EOL
terraform {
  backend "s3" {
    bucket         = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
    key            = "terraform.tfstate"
    region         = "${var.region}"
    encrypt        = true
    dynamodb_table = "${var.dynamodb_name}"
  }
}
EOL
}
