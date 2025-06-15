# Getting started with AWS SQS dead-letter queues
## Terraform
- version : 1.12.2

## How to Use Terraform with Docker Compose
- Navigate to the directory
  - `cd APP_ROOT/terraform/101811ef7093`

- Run the Docker containers in the background
  - `docker compose up -d`

- Enter the Docker container
  - `docker exec -it dlq-lambda-tf /bin/bash`

- Configure the AWS profile
```
aws configure --profile dlq-lambda-tf
AWS Access Key ID [None]: aaaaaa
AWS Secret Access Key [None]: sssssss
Default region name [None]: ap-northeast-1
Default output format [None]:
```

- Run Terraform!
  - `cd ./terraform`
  - `terraform init`
  - `terraform apply`