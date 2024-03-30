variable "prefix" {
  type    = string
  default = "mocktf"
}
variable "env" {
  type    = string
  default = "test"
}

locals {
  app_name = "${var.prefix}-${var.env}"
  s3 = {
    bucket_name = "${local.app_name}-real-name"
  }
  cloudwatch_logs = {
    app_name = local.app_name
  }
  external_module = {
    function_name = "${local.app_name}-lambda1"
    env           = var.env
  }
}