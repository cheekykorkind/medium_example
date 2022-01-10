# SAM으로 CodePipeline상태를 Slack에 보내는 Lambda만들기
- 이 프로젝트는 Codepipeline의 상태에 따라서 Slack에 메세지를 보내는 Lambda를 만들어줍니다.
  - Codepipeline이 이미 존재한다고 가정했습니다.(SAM에서 Codepipeline 안만듭니다)

## SAM 정보
- 버전 : 1.36.0
- AWS CLI : 2.x

## Docker compose로 구축한 SAM 사용법
- 디렉토리 이동합니다
  - `cd APP_ROOT/aws_sam/8eb25c31486c`

- docker 컨테이너를 백그라운드로 실행합니다
  - `docker-compose up -d`

- docker 컨테이너에 들어갑니다
  - `docker exec -it lambda_with_codepipeline_event /bin/bash`

- aws profile설정
  - 한번만 하면 됩니다
    - `docker-aws-config` 디렉토리에 남는 AWS Access Key ID와 Secret Access Key를 .gitignore 하는 구조입니다. **신경쓰이시는 분들은 예제 실행한 다음에 남겨진 파일 지우시바랍니다.**
  - profile명을 정합니다. `lambda_with_codepipeline_event` . profile명은 SAM이 참조할 예정입니다.
```
aws configure --profile lambda_with_codepipeline_event
AWS Access Key ID [None]: aaaaaa
AWS Secret Access Key [None]: sssssss
Default region name [None]: ap-northeast-1
Default output format [None]:
```

- SAM 실행!!
  - `cd sam-app`
  - `sam build`
  - `sam deploy`

