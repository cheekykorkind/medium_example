# terraform/envs/test/main.tf상관없이module하나를 테스트하기

mock_provider "aws" {}

run "s3_module" {

  # # terraform/envs/test/variable.tf를 참조하는건 불가능합니다.
  # variables {
  #   root_params = local.s3 # Error: Invalid reference
  # }

  # module s3가 사용할 variable을 직접 입력합니다.
  variables {
    root_params = {
      bucket_name = "test-real-name"
    }
  }

  module {
    source = "../../modules/s3"
  }

  assert {
    condition     = aws_s3_bucket.my_bucket_1.bucket == var.root_params.bucket_name
    error_message = "incorrect bucket name"
  }
}