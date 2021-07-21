# terraform init
# terraform apply -var="lambda_zip_path=zip파일경로"
output output_lambda_zip_path {
  value = var.lambda_zip_path
}

# terraform init
# terraform apply -var-file="tfvars_exam.tfvars"
output output_tfvars_region {
  value = var.tfvars_region
}