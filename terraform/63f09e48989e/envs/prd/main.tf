module "s3" {
  source = "../../modules/s3"

  root_params = local.s3
}

module "cloudwatch_logs" {
  source = "../../modules/cloudwatch_logs"

  root_params = local.cloudwatch_logs
  s3          = module.s3.out
}

module "external_module" {
  source = "../../modules/external_module"

  root_params = local.external_module
}