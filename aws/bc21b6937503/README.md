# boto3의 client의 프로그래밍 인터페이스를 호출하기까지!
## LocalStack 정보
- 버전 : 3.5.0
## Terraform 정보
- 버전 : 1.9.2
- AWS CLI : 2.x
## Python 정보
- 버전 : 3.12.3

## Docker compose로 구축한 LocalStack 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/aws/bc21b6937503`

- LocalStack docker 컨테이너를 포어그라운드로 실행합니다
  - LocalStack의 Amazon DynamoDB가 사용가능한지 확인하기 위해서 입니다
  - `docker compose up`
  - 아래같은 로그가 보였다면 LocalStack의 Amazon DynamoDB가 사용가능합니다(=Terraform으로 Provisioning 끝낸 상태)

```
boto3-pi     | Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

- boto3-pi-py docker 컨테이너에 들어가서 LocalStack의 Amazon DynamoDB가 사용가능한지 확인합니다.
  - `docker exec -it boto3-pi-py /bin/bash`
  - `python main.py`
- boto3는 `cd APP_ROOT/aws/bc21b6937503/python/packages/boto3` 에 있고, botocore는 `cd APP_ROOT/aws/bc21b6937503/python/packages/botocore` 에 있습니다.
  - 디버깅하고 싶은 곳으로 이동해서 `import traceback` 와 `traceback.print_stack()` 를 입력하면 호출이력을 확인할 수 있습니다.