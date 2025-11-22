provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = var.bucket_name

  tags = {
    Environment = "dev"
  }
}

variable "region" {
  default = "us-east-1"
}

variable "bucket_name" {
  default = "my-demo-tf-bucket-123456"
}
output "bucket_name" {
  value = aws_s3_bucket.demo_bucket.bucket
}
