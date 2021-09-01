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
  region  = "us-east-1"
  access_key = "123"
  secret_key = "xyz"
  skip_credentials_validation = true
  skip_requesting_account_id = true
  skip_metadata_api_check = true
  endpoints {
    lambda         = "http://${var.endpoint_domain}:4566"
    cloudformation = "http://${var.endpoint_domain}:4566"
    s3             = "http://${var.endpoint_domain}:4566"
  }
}