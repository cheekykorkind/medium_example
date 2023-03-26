# Terraform에서 파일 만들때 까지 기다리는 방법
## Terraform 정보
- 버전 : 1.3.6

## Docker compose로 구축한 Terraform 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/terraform/2ae2a7b89e6b`


- docker 컨테이너를 빌드하고 백그라운드로 실행합니다
  - linux에서 docker in docker를 가정하고 있습니다.
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(getent group docker | cut -d: -f3) docker-compose build`
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(getent group docker | cut -d: -f3) docker-compose up -d`

- docker 컨테이너에 들어갑니다
  - `docker exec -it tf-wait-file /bin/bash`
  - 확인해보고 싶은 Terraform이 있는 디렉토리로 이동합니다.

### 파일 만들때 까지 기다리는 `data "local_file"` 을 사용한 Terraform
- `cd with_local_file`
- `terraform init`
- `terraform apply`

### `data "local_file"` 없어서 에러나는 Terraform
- `Call to function "filemd5" failed: open zip_dir/app.zip: no such file or directory.` 을 볼 수 있습니다.
  - `cd without_localfile`
  - `terraform init`
  - `terraform apply`