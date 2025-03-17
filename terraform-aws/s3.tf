resource "aws_s3_bucket" "web_bucket" {
  bucket = "desafio-tecnico-ml-web"

  tags = {
    Name        = "Web-Bucket"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "web_bucket_ownership" {
  bucket = aws_s3_bucket.web_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "web_bucket_access" {
  bucket = aws_s3_bucket.web_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
