terraform {
  required_version = "1.9.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.52.0"
    }
  }
}

provider "aws" {
  profile = "dxs"
  region  = "ap-northeast-1"
}