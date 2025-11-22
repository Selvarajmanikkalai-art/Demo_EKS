provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-remote-state-01"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}


resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

variable "bucket_name" {
  description = "Deployment environment"
  type        = string
  default     = "my-source-code-bucket-codebuild-01"
}



variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
