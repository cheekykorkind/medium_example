# -------------------------------------------------------------------------------------------------------------
# terraform module variable
variable "root_params" {}

# -------------------------------------------------------------------------------------------------------------
# Lambda

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.2.5"

  function_name = var.root_params.function_name
  handler       = "app.lambda_handler"
  runtime       = "python3.12"

  source_path   = "${path.root}/../../modules/external_module/source_dir"
  artifacts_dir = "${path.root}/../../modules/external_module/artifacts_dir"

  # create_role을 false로 하면 테스트 가능했습니다.
  create_role = var.root_params.env == "test" ? false : true
}

# -------------------------------------------------------------------------------------------------------------
# terraform module output
output "out" {
  value = module.lambda_function
}