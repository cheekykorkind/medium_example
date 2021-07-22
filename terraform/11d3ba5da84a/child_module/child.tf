resource "aws_s3_bucket" "child" {
  bucket        = "${var.app_name}-at-child-module-1"
  acl           = "private"
  force_destroy = true
}