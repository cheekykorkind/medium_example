# ECR
resource "aws_ecr_repository" "docker_lambda" {
  name                 = "${var.app_name}-ecr"
  image_tag_mutability = "MUTABLE"
}

data "aws_caller_identity" "current" {}
locals {
  ecr_uri = "${aws_ecr_repository.docker_lambda.repository_url}:latest"
  ecr_region = "ap-northeast-1"
  ecr_profile = "docker-lambda-tf"
  ecr_password_stdin = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com"
}

# Build and push a Docker image for Lambda.
resource "null_resource" "build_and_push_docker_lambda_image" {
  depends_on = [
    aws_ecr_repository.docker_lambda
  ]
  triggers = {
    dependencies_versions = filemd5("${path.cwd}/container/app.py")
  }

  # path.cwd는 terraform apply실행하는곳
  provisioner "local-exec" {
    working_dir = "${path.cwd}/container"
    command = <<-EOT
      aws ecr get-login-password --region "${local.ecr_region}" --profile ${local.ecr_profile} | docker login --username AWS --password-stdin ${local.ecr_password_stdin}
      docker build -t ${local.ecr_uri} -f ./Dockerfile .
      docker push ${local.ecr_uri}
    EOT
  }
}

# Lambda
resource "aws_lambda_function" "app" {
  depends_on = [
    null_resource.build_and_push_docker_lambda_image
  ]

  function_name = "${var.app_name}-app"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = local.ecr_uri
  timeout       = 100
}

# Lambda IAM Role
resource "aws_iam_role" "lambda_role" {
  name               = "${var.app_name}-lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambda_role_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}