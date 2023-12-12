variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy."
}

variable "bucket_name" {
  type        = string
  default     = "tf-state"
  description = "S3 bucket name to store terraform state."
}

variable "s3_acl" {
  type        = string
  default     = "private"
  description = "ACL to apply to the s3 bucket."
}

variable "s3_versioning" {
  type        = string
  default     = "Enabled"
  description = "Versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled. Disabled should only be used when creating or importing resources that correspond to unversioned S3 buckets."
}

variable "s3_object_ownership" {
  type        = string
  default     = "ObjectWriter"
  description = "Object ownership. Valid values: BucketOwnerPreferred, ObjectWriter or BucketOwnerEnforced"
}

variable "dynamodb_name" {
  type        = string
  default     = "terraform-state-lock"
  description = "Name of the DynamoDB table."
}

variable "dynamodb_billing_mode" {
  type        = string
  default     = "PAY_PER_REQUEST"
  description = "Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST."
}

variable "dynamodb_hash_key" {
  type        = string
  default     = "LockID"
  description = "Attribute to use as the hash (partition) key. Must also be defined as an 'attribute'"
}

variable "terraform_user" {
  type        = string
  default     = "terraform-admin"
  description = "Iam user name used by terraform."
}

variable "iam_policy" {
  type        = string
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
  description = "Iam policy attached to terraform iam user."
}

variable "access_key_status" {
  type        = string
  default     = "Active"
  description = "Access key status to apply. Valid values are Active and Inactive."
}

variable "secrets_manager_secret_name" {
  type        = string
  default     = "terraform-admin-secrets"
  description = "AWS Secrets Manager secret name."
}
