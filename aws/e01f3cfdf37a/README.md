# version 정보
- Terraform : 1.3.6
- AWS CLI : 2.x
- Python 3.9.13

## Terraform으로 AWS ECR, S3, IAM Role 만들기
- 디렉토리 이동합니다
  - `cd APP_ROOT/aws/e01f3cfdf37a`

- docker 컨테이너를 백그라운드로 실행합니다
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -g $USER) docker-compose up -d`

- docker 컨테이너에 들어갑니다
  - `docker exec -it create_training_job /bin/bash`

- aws profile설정
  - profile명을 정합니다. `create_training_job` . profile명은 Terraform이 참조할 예정입니다.
```
aws configure --profile create_training_job
AWS Access Key ID [None]: aaaaaa
AWS Secret Access Key [None]: sssssss
Default region name [None]: ap-northeast-1
Default output format [None]:
```

- terraform 실행!!
```
cd terraform
terraform init
terraform apply
```

## ECR에 docker image push하기
- docker 컨테이너에서 exit합니다.
  - `exit`
- 디렉토리 이동합니다
  - `cd APP_ROOT/aws/e01f3cfdf37a`
- ECR에 로그인하고, docker image build하고 push합니다.
  - `bash build_and_push.sh`

## create_training_job.py실행해서 SageMaker training job을 생성합니다.
- docker 컨테이너에 들어갑니다
  - `docker exec -it create_training_job /bin/bash`
- create_training_job.py실행해서 SageMaker training job을 생성합니다.
```
cd py
python create_training_job.py
```