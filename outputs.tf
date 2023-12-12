output "backend_configuration" {
  value = <<EOL
terraform {
  backend "s3" {
    bucket         = "${var.bucket_name}-${random_string.suffix.result}"
    key            = "terraform.tfstate"
    region         = "${var.region}"
    encrypt        = true
    dynamodb_table = "${var.dynamodb_name}-${random_string.suffix.result}"
  }
}
EOL
}

output "generated_secret_name" {
  value = aws_secretsmanager_secret.terraform_admin_secrets.name
}