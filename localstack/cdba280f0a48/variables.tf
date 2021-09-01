# Docker compose에서 고정한 privte ip를 사용했습니다. 개발환경에 따라서 localhost, 127.0.0.1 등 여러가지가 사용가능합니다.
variable endpoint_domain {
  type = string
  default = "192.168.255.6"
}

# Root Module인 main.tf를 기준으로 상대경로를 계산합니다
variable cfm_template {
  type = string
  default = "./sam-app/cfn_tf_samlocal.yaml"
}