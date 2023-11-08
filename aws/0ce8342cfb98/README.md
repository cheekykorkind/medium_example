# AWS Lambda를 테스트할 때 rspec 사용법 팁
## version 정보
- Ruby 3.2.2

## Docker compose로 구축한 rspec사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/aws/0ce8342cfb98`

- docker 컨테이너를 백그라운드로 실행합니다
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -g $USER) docker-compose up -d`

- docker 컨테이너에 들어갑니다
  - `docker exec -it lambda-rspec /bin/bash`

- Gem을 인스톨합니다
  - `bundle config set --local path './vendor'`
  - `bundle install`

- rspec를 실행합니다
  - `bundle exec rspec --format documentation`