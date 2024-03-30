# terraform/modules/external_module/main.tf의 외부모듈 terraform-aws-modules/lambda/aws을 테스트하기

mock_provider "aws" {}

run "external_module_lambda" {
  assert {
    condition     = module.external_module.out.lambda_function_name == local.external_module.function_name
    error_message = "incorrect function name"
  }
}