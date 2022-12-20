# Terraform에서 local-exec랑 docker로 AWS Lambda 패키지 인스톨하고 zip만들기
## Terraform 정보
- 버전 : 1.2.6
- AWS CLI : 2.x

## Docker compose로 구축한 Terraform 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/terraform/857b9f05f983`

- docker 컨테이너를 백그라운드로 실행합니다
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -g $USER) docker-compose up -d`

- docker 컨테이너에 들어갑니다
  - `docker exec -it tf-lambda-build /bin/bash`

- terraform 실행!!
  - `cd ./terraform`
  - `terraform init`
  - `terraform apply`