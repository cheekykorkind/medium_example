resource "aws_codepipeline" "main" {
  name     = var.app_name
  role_arn = var.iam_role_codepipeline_arn

  artifact_store {
    type     = "S3"
    location = var.s3_pipeline_artifact_id
  }

  stage {
    name = "Source"
    # https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference-S3.html
    action {
      category         = "Source"
      configuration    = {
        "PollForSourceChanges" = true
        "S3Bucket"             = var.pipeline_src_bucket_name
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
}