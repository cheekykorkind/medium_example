# TLS를 적용한 MQTT패킷을 Wireshark로 확인하는 방법(paho-mqtt와 AWS IoT Core를 사용)
## 버전 정보
- python : 3.12.3
- paho-mqtt : 2.1.0

## AWS IoT thing와 X.509 인증서를 생성합니다 
- https://docs.aws.amazon.com/ko_kr/kinesisvideostreams/latest/dg/gs-create-thing.html 을 읽고
  - AWS IoT thing과 X.509 인증서를 생성하고 다운로드 합니다
    - 다운로드한 인증서는 `APP_ROOT/aws/38624ae1019a/python/certs` 에 배치합니다.
    - `APP_ROOT/aws/38624ae1019a/python/sub.py` 의 `create_py_default_context()` 의 `certfile` , `keyfile` , `ca_certs` 를 알맞게 수정합니다.
  - AWS 계정의 디바이스 데이터 엔드포인트를 확인하고, `APP_ROOT/aws/38624ae1019a/python/sub.py` 의 `iot_endpoint = "xx.iot.ap-northeast-1.amazonaws.com"` 을 수정합니다
    - `aws iot describe-endpoint --endpoint-type iot:Data-ATS` 부분입니다

## Docker compose로 구축한 Python 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/aws/38624ae1019a`

- Terraform docker 컨테이너를 포어그라운드로 실행합니다
  - `docker compose up`

- 터미널을 새로 열고 tcpdump를 실행합니다 
  - `docker exec -it mqtt-tls-wireshark /bin/bash`
  - `tcpdump -i eth0 -w mqtt1.pcap`
  - 원하는 만큼 실행한 다음에 tcpdump 실행을 중단합니다
  - mqtt1.pcap가 만들어집니다

- 터미널을 새로 열고 sub.py를 실행합니다
  - `docker exec -it mqtt-tls-wireshark /bin/bash`
  - `cd ./python`
  - `python sub.py`
  - 원하는 만큼 실행한 다음에 python 실행을 중단합니다
  - mqttsslkeys.log가 만들어집니다