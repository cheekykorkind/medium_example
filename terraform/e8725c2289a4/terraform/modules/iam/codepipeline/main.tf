data "aws_iam_policy_document" "codepipeline_assumerole" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline" {
  name               = "${var.app_name}-codepipeline"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assumerole.json
}

resource "aws_iam_policy" "codepipeline" {
  name        = "${var.app_name}-codepipeline"
  description = "ecs-pipeline-codepipeline"
  
  policy      = templatefile("./modules/iam/codepipeline/codepipeline_policy.tpl", {
    s3_pipeline_artifact_id   = var.s3_pipeline_artifact_id
    s3_codebuild_buildspec_id = var.s3_codebuild_buildspec_id
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = aws_iam_role.codepipeline.id
  policy_arn = aws_iam_policy.codepipeline.arn
}