# LocalStack v3.5.0을 Terraform으로 Provisioning!
## LocalStack 정보
- 버전 : 3.5.0
## Terraform 정보
- 버전 : 1.9.2
- AWS CLI : 2.x
## Python 정보
- 버전 : 3.12.3

## Docker compose로 구축한 LocalStack 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/localstack/4b72217a1dc7`

- LocalStack docker 컨테이너를 포어그라운드로 실행합니다
  - LocalStack의 Amazon DynamoDB가 사용가능한지 확인하기 위해서 입니다
  - `docker compose up`
  - 아래같은 로그가 보였다면 LocalStack의 Amazon DynamoDB가 사용가능합니다(=Terraform으로 Provisioning 끝낸 상태)

```
localstack350     | Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

- localstack350-py docker 컨테이너에 들어가서 LocalStack의 Amazon DynamoDB가 사용가능한지 확인합니다.
  - `docker exec -it localstack350-py /bin/bash`
  - `python main.py`
  - 아래같은 로그를 확인할 수 있습니다
```
root@f138cf079796:/workspace/myapp# python main.py
{'SK': {'S': 'count'}, 'name': {'S': 'user1'}, 'PK': {'S': 'u#1'}}
```