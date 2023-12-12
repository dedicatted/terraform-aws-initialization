resource "aws_secretsmanager_secret" "terraform_admin_secrets" {
  name = "${var.secrets_manager_secret_name}-${random_string.suffix.result}"
}

resource "aws_secretsmanager_secret_version" "terraform_admin_secret_version" {
  secret_id     = aws_secretsmanager_secret.terraform_admin_secrets.id
  secret_string = jsonencode({
    access_key = aws_iam_access_key.terraform_admin_user_access_keys.id
    secret_key = aws_iam_access_key.terraform_admin_user_access_keys.secret
  })
}