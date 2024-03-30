# -------------------------------------------------------------------------------------------------------------
# terraform module variable
variable "root_params" {}
variable "s3" {}

# -------------------------------------------------------------------------------------------------------------
# Cloudwatch Logs
resource "aws_cloudwatch_log_group" "cwl1" {
  log_group_class = "STANDARD"
  name            = "/${var.root_params.app_name}/${var.s3.bucket}"
}

# -------------------------------------------------------------------------------------------------------------
# terraform module output
output "out" {
  value = aws_cloudwatch_log_group.cwl1
}