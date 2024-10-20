# InfluxDB 실습하면서, 시계열 데이터베이스(TSDB) 개념 정리
## 버전 정보
- influxdb : 2.7

## Docker compose로 확인하기
- 디렉토리 이동합니다
  - `cd APP_ROOT/database/tsdb/d5800703ef63`
- docker 컨테이너를 포어그라운드로 실행합니다
  - `docker compose up`
- 브라우저의 URL localhost:8086에서 InfluxDB UI를 실행하고, DOCKER_INFLUXDB_INIT_USERNAME와 DOCKER_INFLUXDB_INIT_PASSWORD에 설정한 값으로 로그인합니다.
