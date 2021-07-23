# Terraform에서 AWS에 있는 Secrets Manager의 값 참조하기
## Terraform 정보
- 버전 : 1.0.2
- AWS CLI : 2.x

## Docker compose로 구축한 Terraform 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/terraform/d3852b0701d9`

- docker 컨테이너를 백그라운드로 실행합니다
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -g $USER) docker-compose up -d`

- docker 컨테이너에 들어갑니다
  - `docker exec -it aws_import_tf /bin/bash`

- aws profile설정
  - 한번만 하면 됩니다
    - `docker-aws-config` 디렉토리에 남는 AWS Access Key ID와 Secret Access Key를 .gitignore 하는 구조입니다. **신경쓰이시는 분들은 예제 실행한 다음에 남겨진 파일 지우시바랍니다.**
  - profile명을 정합니다. `aws_import_tf` . profile명은 Terraform이 참조할 예정입니다.
```
aws configure --profile aws_import_tf
AWS Access Key ID [None]: aaaaaa
AWS Secret Access Key [None]: sssssss
Default region name [None]: ap-northeast-1
Default output format [None]:
```

- terraform 실행!!
  - `terraform init`
  - `terraform apply`