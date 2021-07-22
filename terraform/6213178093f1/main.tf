#####################################################
# 첫번째 terraform apply
#####################################################
resource "aws_s3_bucket" "root" {
  bucket        = "state-mv-a-1"
  acl           = "private"
  force_destroy = true
}

#####################################################
# 두번째 terraform apply
#####################################################
# module s3_module {
#   source   = "./modules"
# }

#####################################################
# terraform state mv 커맨드 실행하고나면, destroy하려하지 않음
#####################################################
# terraform state mv aws_s3_bucket.root module.s3_module.aws_s3_bucket.root