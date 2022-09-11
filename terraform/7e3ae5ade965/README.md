# Terraform으로 AWS ECS(service 2개) Blue/Green deploy하기
- CodePipeline을 편하게 사용하기 위해서 실험용 리포지토리를 만들고 7e3ae5ade965의 내용을 복사해서 사용하는것을 추천합니다.
  - `deploy_by_cp_s3.sh` 의 `git archive -o build.zip HEAD` 를 편하게 사용하기 위해서 입니다

## Terraform 정보
- 버전 : 1.2.6
- AWS CLI : 2.x

## Docker compose로 구축한 Terraform 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/terraform/7e3ae5ade965`

- docker 컨테이너를 백그라운드로 실행합니다
  - `DOCKER_UID=$(id -u $USER) DOCKER_GID=$(id -g $USER) docker-compose up -d`

- docker 컨테이너에 들어갑니다
  - `docker exec -it two-ecs-deploy-tf /bin/bash`

- aws profile설정
  - 호스트 머신의 aws profile을 read only로 참조하고 있습니다. 호스트머신에서 설정부탁드립니다.
  - profile명을 정합니다. `two-ecs-deploy-tf` . profile명은 Terraform이 참조할 예정입니다.
```
aws configure --profile two-ecs-deploy-tf
AWS Access Key ID [None]: aaaaaa
AWS Secret Access Key [None]: sssssss
Default region name [None]: ap-northeast-1
Default output format [None]:
```

- terraform 실행!!
  - `cd ~/workspace/terraform/7e3ae5ade965/terraform`
  - `terraform init`
  - `terraform apply`

## deploy_by_cp_s3.sh사용법
- terraform apply하고, git push한 다음에 **docker 컨테이너 밖에서** sh deploy_by_cp_s3.sh실행
  - Dockerfile하고 docker-compose.yml 수정하면 docker 컨테이너 안에서도 실행가능