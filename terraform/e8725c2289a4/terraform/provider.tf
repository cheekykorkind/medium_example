terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.60.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "codepipeline-src-s3-tf"
}