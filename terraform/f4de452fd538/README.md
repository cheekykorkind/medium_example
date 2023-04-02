# Terraform으로 AWS Step Functions에서 Map으로 Lambda실행
## Terraform 정보
- 버전 : 1.3.6
- AWS CLI : 2.x

## Docker compose로 구축한 Terraform 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/terraform/f4de452fd538`

- docker 컨테이너를 백그라운드로 실행합니다
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -g $USER) docker-compose up -d`

- docker 컨테이너에 들어갑니다
  - `docker exec -it sfn-standard-tf /bin/bash`

- aws profile설정
```
aws configure --profile sfn-standard-tf
AWS Access Key ID [None]: aaaaaa
AWS Secret Access Key [None]: sssssss
Default region name [None]: ap-northeast-1
Default output format [None]:
```

- terraform 실행!!
  - `cd ./terraform`
  - `terraform init`
  - `terraform apply`

