
# terraform_remote_state로 다른 Terraform의 값 참조하기

## Terraform 정보
- 버전 : 1.3.6
- AWS CLI : 2.x

## Docker compose로 구축한 Terraform 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/terraform/f67c9a9cda22`

- docker 컨테이너를 백그라운드로 실행합니다
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -g $USER) docker-compose -d`

- docker 컨테이너에 들어갑니다
  - `docker exec -it remote-state-tf /bin/bash`

- aws profile설정
```
aws configure --profile remote-state-tf
AWS Access Key ID [None]: aaaaaa
AWS Secret Access Key [None]: sssssss
Default region name [None]: ap-northeast-1
Default output format [None]:
```

- `backend = "remote"(S3)` 를 실행하기
  - remote로 output을 공유하는 Terraform을 실행
    - `cd ./terraform/s3_backend/from_tf`
    - `terraform init`
    - `terraform apply`
  - remote로 output을 공유받는 Terraform을 실행
    - `cd ./terraform/s3_backend/to_tf`
    - `terraform init`
    - `terraform apply`

- `backend = "local"` 를 실행하기
  - remote로 output을 공유하는 Terraform을 실행
    - `cd ./terraform/local_backend/from_tf`
    - `terraform init`
    - `terraform apply`
  - remote로 output을 공유받는 Terraform을 실행
    - `cd ./terraform/local_backend/to_tf`
    - `terraform init`
    - `terraform apply`