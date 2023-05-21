data "terraform_remote_state" "from_tf" {
  backend = "local"

  config = {
    path = "${path.cwd}/../from_tf/terraform.tfstate"
  }
}

output "to_tf_value" {
  value = data.terraform_remote_state.from_tf
}