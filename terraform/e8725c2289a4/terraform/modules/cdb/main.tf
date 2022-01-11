resource "aws_codebuild_project" "main" {
  name          = var.app_name
  description   = "s3"
  build_timeout = 60
  service_role  = var.iam_role_codebuild_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  logs_config {
    cloudwatch_logs {
      status     = "ENABLED"
      group_name = var.cw_logs_codebuild_name
    }
    s3_logs {
      status = "DISABLED"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec_file_path
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "APP_NAME"
      value = var.app_name
    }
  }
}