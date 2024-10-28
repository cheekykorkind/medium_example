# k6 시작하기
## 버전 정보
- k6 : 0.54.0

## Docker compose로 확인하기
- 디렉토리 이동합니다
  - `cd APP_ROOT/testing/k6/6981e09487eb`
- docker 컨테이너를 포어그라운드로 실행합니다
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -u $USER) docker compose up`
- k6-start docker 컨테이너에 들어갑니다.
  - `docker exec -it k6-start /bin/sh`
- k6 실행
  - `k6 run script.js`  
- out을 json으로 설정하기
  - `k6 run --out json=./output/test.json script.js`