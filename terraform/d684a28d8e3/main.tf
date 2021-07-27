# terraform destroy -target aws_ecr_repository.resource_ecr
resource "aws_ecr_repository" "resource_ecr" {
  name                 = "from_resource"
  image_tag_mutability = "MUTABLE"
}

module singular_module {
  source   = "./modules"
  ecr_name = "singular_ecr"
}

# terraform apply -target module.plural_module[1].aws_ecr_repository.module_ecr
module plural_module {
  count    = 3 # 루프 3번 실행
  source   = "./modules"

  ecr_name = "plural_ecr-${count.index}"
}