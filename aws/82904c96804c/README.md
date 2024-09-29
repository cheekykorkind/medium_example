# DynamoDB의 S3 export사용
## Terraform 정보
- 버전 : 1.9.2
- AWS CLI : 2.x

## Docker compose로 구축한 Terraform 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/aws/82904c96804c`

- Terraform docker 컨테이너를 포어그라운드로 실행합니다
  - `docker compose up`

- tf-dynamodb-s3-export docker 컨테이너에 들어가서 Terraform이 사용할 aws cli profile을 만듭니다.
```
$ docker exec -it tf-dynamodb-s3-export /bin/bash
$ aws configure --profile dxs
AWS Access Key ID [None]: xxxxx
AWS Secret Access Key [None]: xxxx
Default region name [None]: ap-northeast-1
Default output format [None]: json
```

- terraform apply로 S3와 DynamoDB를 만듭니다.
  - `terraform init`
  - `terraform apply`

- AWS console에 로그인합니다
  - 생성된 테이블에 아이템을 4개 추가합니다
  - Exports and streams를 클릭하고 Export to S3를 클릭합니다
  - Destination S3 bucket을 선택합니다
  - Full export, Current time, DynamoDB JSON을 선택합니다. 그리고 Export를 클릭합니다.
  - 기다립니다
  - 완료되면 Export ARN을 클릭해서 상세를 확인합니다.
  - Manifest file path의 링크는 `S3://bucket이름/AWSDynamoDB/ExportId값/manifest-summary.json` 형태입니다. 이 링크를 참고해서 실제로 export 한 데이터가 있는 경로 `S3://bucket이름/AWSDynamoDB/ExportId값/data` 로 이동합니다.
  - `S3://bucket이름/AWSDynamoDB/ExportId값/data` 에 gz파일들이 있는지 확인합니다
- APP_ROOT/aws/82904c96804c/python/json_from_gzs.py의 prefix = "AWSDynamoDB/xx/data/"의 xx를 위에서 확인한 ExportId값을 적고 python을 실행합니다.
- combined_gzs.json을 확인합니다.