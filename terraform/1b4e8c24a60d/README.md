# AWS Step Functions(Express) 워크플로의 실행내역 보이도록하기
## Terraform 정보
- 버전 : 1.3.6
- AWS CLI : 2.x

## Docker compose로 구축한 Terraform 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/terraform/1b4e8c24a60d`

- docker 컨테이너를 백그라운드로 실행합니다
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -g $USER) docker-compose up -d`

- docker 컨테이너에 들어갑니다
  - `docker exec -it sfn-express-tf /bin/bash`

- aws profile설정
```
aws configure --profile sfn-express-tf
AWS Access Key ID [None]: aaaaaa
AWS Secret Access Key [None]: sssssss
Default region name [None]: ap-northeast-1
Default output format [None]:
```

- terraform 실행!!
  - `cd ./terraform`
  - `terraform init`
  - `terraform apply`

## 마지막으로
- AWS console에서 `NEW! Visualize express executions in the console` 의 `Enable` 버튼을  직접 클릭해야 합니다.