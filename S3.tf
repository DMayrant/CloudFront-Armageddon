resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "vpc_logs" {
  bucket        = "vpc-logs-${random_id.suffix.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "s3_public_access_block" {
  bucket = aws_s3_bucket.vpc_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.vpc_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "vpc_logs" {
  bucket = aws_s3_bucket.vpc_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
