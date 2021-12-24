# Localstack에 AWS SAM을 Deploy하는 두가지 방법
## Localstack 정보
- 버전 : 0.12.15
## Terraform 정보
- 버전 : 1.0.2
- AWS CLI : 2.x

## Docker compose로 구축한 Localstack 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/localstack/cdba280f0a48`

- Localstack docker 컨테이너를 포어그라운드로 실행합니다
  - Localstack이 사용가능한지 확인하기 위해서 입니다
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -g $USER) docker-compose up`
  - 아래같은 로그가 보였다면 Localstack이 사용가능합니다

```
localstack_sam  | Starting mock Lambda service on http port 4566 ...
...
localstack_sam  | Waiting for all LocalStack services to be ready
localstack_sam  | Ready.
```

### samlocal으로 Localstack에 SAM Deploy하기
- samlocal_and_tf docker 컨테이너에 들어가서 SAM Deploy에 사용할 S3를 미리 만듭니다

```
docker exec -it samlocal_and_tf /bin/bash
aws s3 mb s3://samlocal-cfn-bucket --endpoint-url http://192.168.255.6:4566
```

- SAM을 samlocal으로 build, package, deploy합니다

```
cd ~/terraform/sam-app
samlocal build
samlocal package \
  --s3-bucket samlocal-cfn-bucket \
  --output-template-file ./cfn_samlocal.yaml

samlocal --debug deploy \
  --no-fail-on-empty-changeset \
  --stack-name my-samlocal \
  --template ./cfn_samlocal.yaml
  --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND
```

- samlocal으로 Deploy한 Lambda를 확인하고 동작을 확인합니다

```
aws lambda list-functions --endpoint-url http://192.168.255.6:4566
aws lambda invoke \
  --endpoint-url http://192.168.255.6:4566 \
  --function-name 「list에서 보인 lambda의name」 \
  response.json
```  


### samlocal + Terraform으로 Localstack에 SAM Deploy하기
- samlocal_and_tf docker 컨테이너에 들어가서 SAM Deploy에 사용할 S3를 미리 만듭니다

```
docker exec -it samlocal_and_tf /bin/bash
aws s3 mb s3://samlocal-tf-cfn-bucket --endpoint-url http://192.168.255.6:4566
```

- SAM을 samlocal으로 build, package합니다

```
cd ~/terraform/sam-app
samlocal build
samlocal package \
  --s3-bucket samlocal-tf-cfn-bucket \
  --output-template-file ./cfn_tf_samlocal.yaml
```

- samlocal가 cfn_tf_samlocal.yaml 을 생성하면 terraform apply합니다
  - Terraform스크립트에서 `cfn_tf_samlocal.yaml` 가 작성되는 경로를 미리 맞춰두었기에 가능합니다

```
cd ~/terraform
terraform init
terraform apply
```

- samlocal으로 Deploy한 Lambda를 확인하고 동작을 확인합니다

```
aws lambda list-functions --endpoint-url http://192.168.255.6:4566
aws lambda invoke \
  --endpoint-url http://192.168.255.6:4566 \
  --function-name 「list에서 보인 lambda의name」 \
  response.json
```