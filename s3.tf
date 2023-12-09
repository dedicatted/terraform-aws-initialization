resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  rule {
    object_ownership = var.s3_object_ownership
  }
}

resource "aws_s3_bucket_acl" "s3_acl" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  acl    = var.s3_acl

  depends_on = [ aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership ]
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  versioning_configuration {
    status = var.s3_versioning
  }
}