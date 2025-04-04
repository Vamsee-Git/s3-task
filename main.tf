provider "aws" {
  region = "ap-south-1"
}

# Create an S3 bucket.
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "new-s3-bucket-vamsee"
  acl    = "private"
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption for the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Upload a sample file test.txt to the S3 bucket
resource "aws_s3_bucket_object" "test_file" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key    = "test.txt"
  source = "test.txt"
  acl    = "public-read"
}
