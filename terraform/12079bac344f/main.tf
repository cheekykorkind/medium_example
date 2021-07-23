resource "aws_ecr_repository" "main" {
  name                 = "show_me_console_ecr"
  image_tag_mutability = "MUTABLE"
}
