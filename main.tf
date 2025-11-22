terraform {
  required_version = ">= 1.4.0"

  backend "s3" {
    bucket = "amazondatasystem"
    key    = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

# -----------------------
# S3 bucket for TF state
# -----------------------
resource "aws_s3_bucket" "tf_state" {
  bucket = "terraform-remote-state-01"

  tags = {
    Name        = "terraform-remote-state"
    Environment = "infra"
  }
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_sse" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state_block" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -----------------------
# DynamoDB table for locks
# -----------------------
resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-lock-table"
    Environment = "infra"
  }
}

# -----------------------
# Example: Demo S3 bucket
# -----------------------
resource "aws_s3_bucket" "demo_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "dev"
  }
}

resource "aws_s3_bucket_public_access_block" "demo_bucket_block" {
  bucket                  = aws_s3_bucket.demo_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy resources."
}

variable "bucket_name" {
  type        = string
  default     = "my-demo-tf-bucket-123456"
  description = "Name of the demo S3 bucket."
}

output "bucket_name" {
  value = aws_s3_bucket.demo_bucket.bucket
}