# AWS Lambda를 테스트할 때 pytest 사용법 팁
## version 정보
- Python 3.10.11
- pytest 7.4.2
- boto3 1.28.44

## Docker compose로 구축한 pytest사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/aws/2799101f1a20`

- docker 컨테이너를 백그라운드로 실행합니다
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -g $USER) docker-compose up -d`

- docker 컨테이너에 들어갑니다
  - `docker exec -it amplify-pytest /bin/bash`

- pytest를 실행합니다
  - `cd amplify/backend/pytest`
  - `pytest`

