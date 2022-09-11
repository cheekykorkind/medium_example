variable app_name {
  type = string
  default = "two_ecs_deploy"
}

variable app_name_two {
  type = string
  default = "two_ecs_deploy_2"
}

variable buildspec_file_path {
  type = string
  default = "./server/buildspec.yml"
}

variable vpc_cidr {
  type = string
  default  = "10.1.0.0/16"
}