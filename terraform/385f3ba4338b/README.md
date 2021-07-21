# Terraform변수정리(커맨드라인 인자, 데폴트값, tpl파일로 사용)

## Terraform 정보
- 버전 : 1.0.2
- AWS CLI : 2.x

## 실험 순서
1. docker compose가 있는 디렉토리로 이동합니다. 
  - `cd terraform/385f3ba4338b`
2. docker 컨테이너를 백그라운드로 실행합니다.
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -g $USER) docker-compose up -d`
3. docker 컨테이너에 들어갑니다.
  - `docker exec -it var_examples_tf /bin/bash`

4. 예제가 있는 디렉토리로 이동해서 실험합니다.
  - 커맨드라인 인자로 Terraform 변수에 값을 할당하는 경우
    - `cd ~/terraform/examples/command-line`
    - `terraform init`
    - `terraform apply -var="lambda_zip_path=zip파일경로"`
  - 커맨드라인에서 tfvars을 지정해서 Terraform 변수에 값을 할당하는 경우
    - `cd ~/terraform/examples/command-line`
    - `terraform init`
    - `terraform apply -var-file="tfvars_exam.tfvars"`
  - Terraform 변수의 디폴트 값을 그대로 사용하는 경우
    - `cd ~/terraform/examples/set-default`
    - `terraform init`
    - `terraform apply`
  - tpl파일을 활용하는 경우
    - `cd ~/terraform/examples/tpl`
    - `terraform init`
    - `terraform apply`
