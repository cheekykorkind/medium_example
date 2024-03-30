mock_provider "aws" {}

# terraform/envs/test/main.tf를 테스트하기
run "aws_cloudwatch_log_group_sum1" {
  assert {
    condition     = module.cloudwatch_logs.out.name == "/${local.cloudwatch_logs.app_name}/${module.s3.out.bucket}"
    error_message = "incorrect aws cloudwatch log group name"
  }
}
