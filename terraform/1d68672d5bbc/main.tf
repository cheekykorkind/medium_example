resource "aws_ecr_repository" "default_region" {
  name                 = "default_is_ap_northeast_1"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "select_region" {
  name                 = "select_region_by_resource_way"
  image_tag_mutability = "MUTABLE"

  provider = aws.alias_us_esat_1
}

module erc_module {
  source    = "./modules"

  providers = {
    aws.alter = aws.alias_us_esat_1
  }
  # # 0.14버전까지 문제없었던 코드. 
  # providers = {
  #   aws = aws.alias_us_esat_1
  # }
}