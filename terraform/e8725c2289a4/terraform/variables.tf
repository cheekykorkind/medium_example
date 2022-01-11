
# 例）export TF_VAR_valvalue=xxxxxxxxxxx
variable app_name {
  type = string
  default = "codepipeline-src-s3"
}

variable app_env {
  type = string
  default = "prd"
}

variable buildspec_file_path {
  type = string
  default = "buildspec.yml"
}