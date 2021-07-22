data "aws_caller_identity" "self" {}

output output_account_id {
  value = data.aws_caller_identity.self.account_id
}