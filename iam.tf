resource "aws_iam_user" "terraform_admin_user" {
  name = "${var.terraform_user}-${random_string.suffix.result}"
}

resource "aws_iam_user_policy_attachment" "terraform_admin_attachment" {
  user       = aws_iam_user.terraform_admin_user.name
  policy_arn = var.iam_policy
}

resource "aws_iam_access_key" "terraform_admin_user_access_keys" {
  user   = aws_iam_user.terraform_admin_user.name
  status = var.access_key_status
}
