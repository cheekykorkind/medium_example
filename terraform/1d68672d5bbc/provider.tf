terraform {
  required_version = ">= 1.0.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.50.0"
    }
  }
}

# 디폴트로 사용될 provider
provider aws {
  region  = "ap-northeast-1"
  profile = "use_alias_tf"
}

# 다른 리전을 설정한 alias를 갖는 provider
provider aws {
  alias   = "alias_us_esat_1"

  region  = "us-east-1"
  profile = "use_alias_tf"
}