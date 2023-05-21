data "terraform_remote_state" "from_tf" {
  backend = "s3"

  config = {
    bucket  = "rs-backend-132253" # Set the S3 bucket name of the backend that ./terraform/s3_backend/from_tf/provider.tf is using.
    key     = "s3-from-tf" # Set the S3 bucket key name of the backend that ./terraform/s3_backend/from_tf/provider.tf is using.
    region  = "ap-northeast-1"
    profile = "remote-state-tf"
  }
}

output "to_tf_value" {
  value = data.terraform_remote_state.from_tf
}

