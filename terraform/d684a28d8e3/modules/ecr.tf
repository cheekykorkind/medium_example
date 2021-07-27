resource "aws_ecr_repository" "module_ecr" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"
}