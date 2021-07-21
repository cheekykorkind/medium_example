/*
docker compose에서 환경변수에 AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY등을 EXAMPLE값으로 등록했기때문에 Terraform실행에는 문제없습니다.
environment:
  AWS_ACCESS_KEY_ID: AKIAIOSFODNN7EXAMPLE
  AWS_SECRET_ACCESS_KEY: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
  AWS_DEFAULT_REGION: us-east-1
*/
provider aws {

}