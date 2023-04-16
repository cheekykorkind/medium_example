resource "aws_s3_bucket" "sfn" {
  bucket = "${var.app_name}-sfn"
}
resource "aws_s3_bucket_acl" "sfn" {
  bucket = aws_s3_bucket.sfn.id
  acl    = "private"
}
resource "aws_s3_bucket_public_access_block" "sfn" {
  bucket                  = aws_s3_bucket.sfn.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}