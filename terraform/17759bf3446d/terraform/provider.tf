terraform {
  required_version = ">= 1.3.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.45.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "docker-lambda-tf"
}