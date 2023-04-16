# Terraform으로 AWS Step Functions에서 Distributed Map으로 Lambda실행
## Terraform 정보
- 버전 : 1.3.6
- AWS CLI : 2.x

## Docker compose로 구축한 Terraform 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/terraform/99d58406f165`

- docker 컨테이너를 백그라운드로 실행합니다
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -g $USER) docker-compose up -d`

- docker 컨테이너에 들어갑니다
  - `docker exec -it sfn-standard-distributed-map-tf /bin/bash`

- aws profile설정
```
aws configure --profile sfn-standard-distributed-map-tf
AWS Access Key ID [None]: aaaaaa
AWS Secret Access Key [None]: sssssss
Default region name [None]: ap-northeast-1
Default output format [None]:
```

- terraform 실행!!
  - `cd ./terraform`
  - `terraform init`
  - `terraform apply`

## Step Functions가 Map에 사용할 CSV를 S3에 업로드
- AWS console에서 map_source.csv를 S3에 업로드
이하의 s3에 업로드합니다.
```
resource "aws_s3_bucket" "sfn" {
  bucket = "${var.app_name}-sfn"
}
```

## Step Functions을 실행
- AWS console에서 Start excution을 클릭해서 실행!
