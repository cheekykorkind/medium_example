# module에 alias 적용할때 경고받지 않으려면 명시적으로 선언해야합니다.
terraform {
  required_version = ">= 1.0.2"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 3.50.0"
      configuration_aliases = [ aws.alter ] # aws.alter는 module이 선언한 alias. 여기에 main.tf의 providers에서 provider.tf에서 선언한 alias를 적용함.
    }
  }
}

resource "aws_ecr_repository" "select_region" {
  name                 = "select_region_by_module_way"
  image_tag_mutability = "MUTABLE"
}