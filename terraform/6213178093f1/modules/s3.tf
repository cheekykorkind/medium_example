resource "aws_s3_bucket" "root" {
  bucket        = "state-mv-a-1"
  acl           = "private"
  force_destroy = true
}