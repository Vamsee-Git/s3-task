provider "aws" {
  region = "ap-south-1"
}

# Create an S3 bucket.
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "new-s3-bucket-vamsee"
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
resource "aws_s3_object" "test_file" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key    = "test.txt"
  source = "test.txt"
}
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "s3:GetObject",
        Resource = "arn:aws:s3:::new-s3-bucket-vamsee/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.example]
}
