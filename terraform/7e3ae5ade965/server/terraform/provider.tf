terraform {
  required_version = ">= 1.2.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "two-ecs-deploy-tf"
}
