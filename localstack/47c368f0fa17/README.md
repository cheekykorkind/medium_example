# Localstack을 Terraform으로 Provisioning!
## Localstack 정보
- 버전 : 0.12.15
## Terraform 정보
- 버전 : 1.0.2
- AWS CLI : 2.x

## Docker compose로 구축한 Localstack 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/localstack/47c368f0fa17`

- Localstack docker 컨테이너를 포어그라운드로 실행합니다
  - Localstack이 init_my_aws의 스크립트를 실행했는지 확인하기 위해서입니다.
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -g $USER) docker-compose up`
  - 아래같은 로그가 보였다면 Localstack의 Lambda가 사용가능합니다(=Terraform으로 Provisioning해도 됩니다)

```
localstack_init_by_tf  | Starting mock Lambda service on http port 4566 ...
...
localstack_init_by_tf  | Waiting for all LocalStack services to be ready
localstack_init_by_tf  | Ready.
```

- check_localstack_init_by_tf docker 컨테이너에 들어가서 Terraform으로 Provisioning합니다
  - `docker exec -it check_localstack_init_by_tf /bin/bash`
  - `terraform init`
  - `terraform apply`

- check_localstack_init_by_tf docker 컨테이너에서 aws cli로 Lambda를 호출해봅니다
  - 결과는 response.json에서 확인가능합니다.

```
aws lambda invoke \
  --region us-east-1 \
  --endpoint-url http://192.168.255.4:4566 \
  --function-name hello_lambda \
  response.json
```