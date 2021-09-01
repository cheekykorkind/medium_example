resource "aws_cloudformation_stack" "from_sam" {
  name = "from_sam"
  template_body = file(var.cfm_template)
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_AUTO_EXPAND"]
}