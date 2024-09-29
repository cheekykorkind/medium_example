import os
import ssl
import paho.mqtt.client as mqtt

# def tls_set를 보고 certfile, keyfile, ca_certs 설정이나, paho-mqtt의 MQTT client module이 default라고 설정한 내용을 따라했습니다.
# https://github.com/eclipse/paho.mqtt.python/blob/d45de3737879cfe7a6acc361631fa5cb1ef584bb/src/paho/mqtt/client.py#L1205
def create_py_default_context():
    # TLS 세션 키 로그 파일 설정
    ssl_keylog_file = "/workspace/myapp/python/mqttsslkeys.log"

    # SSLContext 객체 생성 (TLS 설정)
    py_default_context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)

    # python 표준 라이브러리 ssl의 keylog 기능 사용
    py_default_context.keylog_filename = ssl_keylog_file

    certfile = "./certs/certificate.pem.crt"
    keyfile = "./certs/private.pem.key"
    ca_certs = "./certs/AmazonRootCA1.pem"
    keyfile_password = None
    py_default_context.load_cert_chain(certfile, keyfile, keyfile_password)
    py_default_context.verify_mode = ssl.CERT_REQUIRED
    py_default_context.load_verify_locations(ca_certs)
    return py_default_context

# 브로커에 연결시 호출
def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("브로커 연결 되었습니다")

        # 구독할 주제 설정
        client.subscribe("t1/some/topic")
    else:
        print(f"Connection failed with code {rc}")

# 메시지를 수신시 호출
def on_message(client, userdata, msg):
    print(f"메세지 수신 : {msg.payload.decode()} topic: {msg.topic}")


# AWS 계정의 디바이스 데이터 엔드포인트를 README.md에서 확인하고 작성합니다
iot_endpoint = "xx.iot.ap-northeast-1.amazonaws.com"

# MQTT 클라이언트 생성
client = mqtt.Client(protocol=mqtt.MQTTv311)
client.on_connect = on_connect
client.on_message = on_message

# TLS 설정 (위에서 설정한 python 표준 라이브러리 ssl의 context를 사용)
client.tls_set_context(create_py_default_context())

# MQTT 브로커에 연결
client.connect(iot_endpoint, 8883, keepalive=20)
client.loop_forever()