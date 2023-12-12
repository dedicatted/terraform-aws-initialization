# Terraform Module: terraform-aws-initialization
# This module facilitates the creation of AWS S3 bucket, DynamoDB and IAM user as initial configuration for managing Terraform with remote state.

## Overview
The `terraform-aws-initialization` module simplifies the setup of key infrastructure components for managing AWS resources using Terraform. This includes configuring an S3 bucket for Terraform state storage, DynamoDB for state locking, and an IAM user with admin permissions for Terraform operations.

## Usage
```hcl
//Configuration to call the module
module initialization {
  source = "github.com/dedicatted/terraform-aws-initialization"
}
```
```hcl
//Configuration to call the module and retrieve value from outputs
module initialization {
  source = "github.com/dedicatted/terraform-aws-initialization"
}

output "backend_configuration" {
  value = module.initialization.backend_configuration
}
```
## Post configuration
Once `terraform apply` is executed, S3 bucket, DynamoDB and IAM user will be created. You will find IAM user's access/secret keys stored in AWS Secrets Manager service.

To use created infrastructure in your workloads take the value of `"backend_configuration" output` and add to your configurations: 

```hcl
terraform {
  backend "s3" {
    bucket         = "tf-state-<random-prefix>"
    key            = "terraform.tfstate"
    region         = "<region>"
    encrypt        = true
    dynamodb_table = "<dynamodb-name>-<random-prefix>"
    }
}
```
Example for deploying AWS SNS topic and storing Terraform state in S3 bucket and DynamoDB Table to use for state locking and consistency:

```hcl
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "tf-state-<random-prefix>"
    key            = "terraform.tfstate"
    region         = "<region>"
    encrypt        = true 
    dynamodb_table = "<dynamodb-name>-<random-prefix>"
  }
}

resource "aws_sns_topic" "topic" {
  name  = "my-test-sns-topic"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.47 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.30.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.terraform_state_lock](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_access_key.terraform_admin_user_access_keys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.terraform_admin_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.terraform_admin_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_s3_bucket.terraform_state_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.s3_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_versioning.s3_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_secretsmanager_secret.terraform_admin_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.terraform_admin_secret_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_key_status"></a> [access\_key\_status](#input\_access\_key\_status) | Access key status to apply. Valid values are Active and Inactive. | `string` | `"Active"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | S3 bucket name to store terraform state. | `string` | `"tf-state"` | no |
| <a name="input_dynamodb_billing_mode"></a> [dynamodb\_billing\_mode](#input\_dynamodb\_billing\_mode) | Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY\_PER\_REQUEST. | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_dynamodb_hash_key"></a> [dynamodb\_hash\_key](#input\_dynamodb\_hash\_key) | Attribute to use as the hash (partition) key. Must also be defined as an 'attribute' | `string` | `"LockID"` | no |
| <a name="input_dynamodb_name"></a> [dynamodb\_name](#input\_dynamodb\_name) | Name of the DynamoDB table. | `string` | `"terraform-state-lock"` | no |
| <a name="input_iam_policy"></a> [iam\_policy](#input\_iam\_policy) | Iam policy attached to terraform iam user. | `string` | `"arn:aws:iam::aws:policy/AdministratorAccess"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region to deploy. | `string` | `"us-east-1"` | no |
| <a name="input_s3_acl"></a> [s3\_acl](#input\_s3\_acl) | ACL to apply to the s3 bucket. | `string` | `"private"` | no |
| <a name="input_s3_object_ownership"></a> [s3\_object\_ownership](#input\_s3\_object\_ownership) | Object ownership. Valid values: BucketOwnerPreferred, ObjectWriter or BucketOwnerEnforced | `string` | `"ObjectWriter"` | no |
| <a name="input_s3_versioning"></a> [s3\_versioning](#input\_s3\_versioning) | Versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled. Disabled should only be used when creating or importing resources that correspond to unversioned S3 buckets. | `string` | `"Enabled"` | no |
| <a name="input_secrets_manager_secret_name"></a> [secrets\_manager\_secret\_name](#input\_secrets\_manager\_secret\_name) | AWS Secrets Manager secret name. | `string` | `"terraform-admin-secrets"` | no |
| <a name="input_terraform_user"></a> [terraform\_user](#input\_terraform\_user) | Iam user name used by terraform. | `string` | `"terraform-admin"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backend_configuration"></a> [backend\_configuration](#output\_backend\_configuration) | n/a |
| <a name="output_generated_secret_name"></a> [generated\_secret\_name](#output\_generated\_secret\_name) | n/a |
