terraform {
  required_version = ">= 1.3.6"

  backend "s3" {
    bucket  = "rs-backend-132253" # Set a unique S3 bucket name.
    key     = "s3-from-tf"
    region  = "ap-northeast-1"
    profile = "remote-state-tf"
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.45.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "remote-state-tf"
}