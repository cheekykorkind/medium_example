/*
  1. AWS상에 미리 「aws-import-a-1」버킷을 만들어둡니다.
  2. Terraform 도큐먼트의 resources항목에서 어떤 요소로 import가능한지 확인합니다.
      https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import
  3. 아래의 「resource "aws_s3_bucket" "main"」 를 주석해제합니다.
  4. terraform import 'aws_s3_bucket.main' aws-import-a-1
*/
# resource "aws_s3_bucket" "main" {
#   bucket        = "aws-import-a-1"
#   acl           = "private"
#   force_destroy = true
# }