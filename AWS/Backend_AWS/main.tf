resource "aws_s3_bucket" "s3-alias" {
  bucket = var.s3-name
}

resource "aws_s3_bucket_acl" "s3-acl-alias" {
  bucket = aws_s3_bucket.s3-alias.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning-alias" {
  bucket = aws_s3_bucket.s3-alias.id
  versioning_configuration {
    status = "Enabled"
  }
}