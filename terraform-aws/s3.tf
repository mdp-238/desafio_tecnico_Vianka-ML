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
