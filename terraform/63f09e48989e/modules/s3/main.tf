# -------------------------------------------------------------------------------------------------------------
# terraform module variable
variable "root_params" {}

# -------------------------------------------------------------------------------------------------------------
# Cloudwatch Logs
resource "aws_s3_bucket" "my_bucket_1" {
  bucket = var.root_params.bucket_name
}

# -------------------------------------------------------------------------------------------------------------
# terraform module output
output "out" {
  value = aws_s3_bucket.my_bucket_1
}