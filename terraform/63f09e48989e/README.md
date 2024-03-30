# Terraform에서 mock을 활용해서 테스트하기(terraform test)

## Terraform 정보
- 버전 : 1.7.5
- AWS CLI : 2.x

## 실험 순서
1. docker compose가 있는 디렉토리로 이동합니다. 
  - `cd terraform/63f09e48989e`
2. docker 컨테이너를 백그라운드로 실행합니다.
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -g $USER) docker-compose up -d`
3. docker 컨테이너에 들어갑니다.
  - `docker exec -it tf-mock-test /bin/bash`
4. 예제가 있는 디렉토리로 이동해서 실험합니다.
  - `cd ./envs/test/`
  - `terraform init`
  - `terraform test`