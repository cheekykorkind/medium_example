resource "aws_s3_bucket" "root" {
  bucket        = "${var.app_name}-at-root-module-1"
  acl           = "private"
  force_destroy = true
}

# 「resource」이나「module」없으면 medium_example/terraform/11d3ba5da84a/child_module/child.tf 를 참조하려고도 하지않음

# 「resource」형식으로는 참조 불가능
# resource "aws_s3_bucket" "child" {
#   source   = "./child_module"
# }

# # 「module」형식이라면 참조 가능
# module s3_child {
#   source   = "./child_module"
# }