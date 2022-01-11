# module.iam_codepipeline.role
module iam_codepipeline {
  source                    = "./modules/iam/codepipeline"

  app_name                  = var.app_name
  s3_pipeline_artifact_id   = aws_s3_bucket.pipeline_artifact.id
  s3_codebuild_buildspec_id = aws_s3_bucket.pipeline_src.id
}

# module.iam_codebuild.role
module iam_codebuild {
  source                   = "./modules/iam/codebuild/web_build"

  app_name                 = var.app_name
  s3_pipeline_artifact_arn = aws_s3_bucket.pipeline_artifact.arn
  cw_logs_codebuild_arn    = aws_cloudwatch_log_group.codebuild.arn
}

module codepipeline {
  source                    = "./modules/cd_pipeline"

  app_name                  = var.app_name
  iam_role_codepipeline_arn = module.iam_codepipeline.role.arn
  s3_pipeline_artifact_id   = aws_s3_bucket.pipeline_artifact.id

  pipeline_src_bucket_name  = aws_s3_bucket.pipeline_src.bucket
}


module codebuild {
  source                 = "./modules/cdb"

  app_name               = var.app_name
  iam_role_codebuild_arn = module.iam_codebuild.role.arn
  cw_logs_codebuild_name = aws_cloudwatch_log_group.codebuild.name

  buildspec_file_path    = var.buildspec_file_path
}


resource "aws_s3_bucket" "pipeline_artifact" {
  bucket        = "${var.app_name}-pipeline-artifact"
  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket" "pipeline_src" {
  bucket        = "${var.app_name}-pipeline-src"
  acl           = "private"
  force_destroy = true

  # codepipeline의 정확한 참조를 위해 필요
  versioning {
    enabled = true
  }
}

resource "aws_cloudwatch_log_group" "codebuild" {
  name = "/codebuild/${var.app_name}"
}

resource "aws_cloudwatch_log_group" "ecs_task_definitions" {
  name = "/ecs/task-definitions/${var.app_name}"
}

resource "aws_cloudwatch_log_group" "ecs_task_definitions_nginx" {
  name = "/ecs/task-definitions/${var.app_name}-nginx"
}