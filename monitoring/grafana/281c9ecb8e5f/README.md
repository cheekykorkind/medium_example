# InfluxDB를 사용하는 Grafana 첫걸음
## 버전 정보
- Influxdb : 2.7
- Grafana(OSS) : 11.2.2

## Docker compose로 확인하기
- 디렉토리 이동합니다
  - `cd APP_ROOT/monitoring/grafana/281c9ecb8e5f`
- docker 컨테이너를 포어그라운드로 실행합니다
  - `docker compose up`
- 브라우저의 URL localhost:3000에서 GF_SECURITY_ADMIN_USER와 GF_SECURITY_ADMIN_PASSWORD에서 설정한 값으로 로그인 합니다
      