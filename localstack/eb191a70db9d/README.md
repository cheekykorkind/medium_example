# LocalStack이라면 개발할때 실제 AWS사용하듯 개발가능하다
## Localstack 정보
- 버전 : 0.12.15

## Docker compose로 구축한 Localstack 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/localstack/eb191a70db9d`

- Localstack docker 컨테이너를 포어그라운드로 실행합니다
  - Localstack이 init_my_aws의 스크립트를 실행했는지 확인하기 위해서입니다.
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -g $USER) docker-compose up`

- aws cli docker 컨테이너에 들어가서 Localstack이 만든 s3를 확인합니다.
  - `docker exec -it check_localstack_init_by_shell /bin/bash`
  - `aws s3 ls --endpoint-url http://192.168.255.2:4566`