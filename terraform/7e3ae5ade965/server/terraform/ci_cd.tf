##########################
##  codepipeline
##########################
resource aws_iam_role cp_service_role {
  name               = "${var.app_name}-codepipeline"
  assume_role_policy = data.aws_iam_policy_document.cp_assume_role_policy.json
}

resource aws_iam_role_policy cp_service_role {
  name   = "${var.app_name}-codepipeline-policy"
  role   = aws_iam_role.cp_service_role.id
  policy = data.aws_iam_policy_document.cp_policy.json
}

data aws_iam_policy_document cp_assume_role_policy {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

data aws_iam_policy_document cp_policy {
  statement {
    effect    = "Allow"
    actions   = [
      "iam:PassRole"
    ]
    resources = [
      "*"
    ]
    condition {
      test = "StringEqualsIfExists"
      variable = "iam:PassedToService"
      values = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }

  statement {
    effect    = "Allow"
    actions   = [
      "s3:GetBucketVersioning",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = [
      "ecr:DescribeImages"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = [
      "elasticloadbalancing:*",
      "cloudwatch:*",
      "sns:*",
      "ecs:*",
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_codepipeline" "main" {
  name     = var.app_name
  role_arn = aws_iam_role.cp_service_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.pipeline_artifact.id
  }

  stage {
    name = "Source"
    # https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference-S3.html
    action {
      category         = "Source"
      configuration    = {
        "PollForSourceChanges" = true
        "S3Bucket"             = aws_s3_bucket.pipeline_src.bucket
        "S3ObjectKey"          = "build.zip"
      }
      name             = "s3_source"
      output_artifacts = ["s3_source"]
      owner            = "AWS"
      provider         = "S3"
      run_order        = 1
      version          = "1"
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 2
      input_artifacts  = ["s3_source"]
      output_artifacts = ["build_out"]
      configuration    = {
        ProjectName = var.app_name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"
      run_order       = 3
      input_artifacts = ["build_out"]
      configuration   = {
        ApplicationName                = aws_codedeploy_app.main.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.main.deployment_group_name
        TaskDefinitionTemplateArtifact = "build_out"
        TaskDefinitionTemplatePath     = "task_definition.json"
        AppSpecTemplateArtifact        = "build_out"
        AppSpecTemplatePath            = "appspec.yaml"
      }
    }
    action {
      name            = "DeployTwo"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"
      run_order       = 3
      input_artifacts = ["build_out"]
      configuration   = {
        ApplicationName                = aws_codedeploy_app.main.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.two.deployment_group_name
        TaskDefinitionTemplateArtifact = "build_out"
        TaskDefinitionTemplatePath     = "task_definition_two.json"
        AppSpecTemplateArtifact        = "build_out"
        AppSpecTemplatePath            = "appspec_two.yaml"
      }
    }
  }
}

resource "aws_s3_bucket" "pipeline_artifact" {
  bucket        = "${replace(var.app_name, "_", "-")}-pipeline-artifact"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "pipeline_artifact_bucket_acl" {
  bucket = aws_s3_bucket.pipeline_artifact.id
  acl    = "private"
}

resource "aws_s3_bucket" "pipeline_src" {
  bucket        = "${replace(var.app_name, "_", "-")}-pipeline-src"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "pipeline_src_bucket_acl" {
  bucket = aws_s3_bucket.pipeline_src.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "pipeline_src_versioning" {
  bucket = aws_s3_bucket.pipeline_src.id
  versioning_configuration {
    status = "Enabled"
  }
}

##########################
##  codebuild
##########################
data "aws_iam_policy_document" "codebuild_policy_document" {
  statement {
    effect    = "Allow"
    actions   = [
      "s3:List*",
      "s3:Get*",
      "s3:PutObject"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "ecr:*"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "ecs:ListTaskDefinitions",
      "ecs:DescribeTaskDefinition"
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "codebuild_assume_policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["codebuild.amazonaws.com"]
      type = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codebuild_role" {
  name = "${var.app_name}_codebuild_role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_policy.json

  inline_policy {
    name   = "${var.app_name}_codebuild_inline_policy"
    policy = data.aws_iam_policy_document.codebuild_policy_document.json
  }
}

resource "aws_codebuild_project" "main" {
  name          = var.app_name
  description   = "s3"
  build_timeout = 60
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  logs_config {
    cloudwatch_logs {
      status     = "ENABLED"
      group_name = aws_cloudwatch_log_group.codebuild.name
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
    environment_variable {
      name  = "MAIN_REPOSITORY_URL"
      value = aws_ecr_repository.main.repository_url
    }
    environment_variable {
      name  = "ECS_FAMILY"
      value = aws_ecs_task_definition.main.family
    }
    environment_variable {
      name  = "ONE_CONTAINER_NAME"
      value = var.app_name
    }
    environment_variable {
      name  = "ECS_TWO_FAMILY"
      value = aws_ecs_task_definition.two.family
    }
    environment_variable {
      name  = "TWO_CONTAINER_NAME"
      value = var.app_name_two
    }
  }
}

resource "aws_cloudwatch_log_group" "codebuild" {
  name = "/codebuild/${var.app_name}"
}


##########################
##  codedeploy
##########################
resource aws_iam_role cd_service_role {
  name               = "${var.app_name}-codedeploy"
  assume_role_policy = data.aws_iam_policy_document.cd_assume_role_policy.json
}

resource aws_iam_role_policy_attachment cd_service_role_policy {
  role       = aws_iam_role.cd_service_role.id
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

data aws_iam_policy_document cd_assume_role_policy {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_codedeploy_app" "main" {
  compute_platform = "ECS"
  name             = var.app_name
}

resource "aws_codedeploy_deployment_group" "main" {
  deployment_group_name  = var.app_name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  app_name               = aws_codedeploy_app.main.name
  service_role_arn       = aws_iam_role.cd_service_role.arn
  
  auto_rollback_configuration {
    enabled = true
    events  = [
      "DEPLOYMENT_FAILURE"
    ]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.main.name
    service_name = aws_ecs_service.main.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [
          aws_lb_listener.main.arn
        ]
      }
      target_group {
        name = aws_lb_target_group.blue.name
      }
      target_group {
        name = aws_lb_target_group.green.name
      }
    }
  }
}