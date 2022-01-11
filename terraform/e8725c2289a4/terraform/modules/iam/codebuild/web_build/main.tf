data "aws_iam_policy_document" "codebuild_assumerole" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    effect    = "Allow"
    actions   = [
      "s3:List*",
      "s3:Get*",
      "s3:PutObject"
    ]
    resources = [
      var.s3_pipeline_artifact_arn,
      "${var.s3_pipeline_artifact_arn}/*"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${var.cw_logs_codebuild_arn}:*"
    ]
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "${var.app_name}-codebuild"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assumerole.json
}

resource "aws_iam_role_policy" "codebuild" {
  name   = "${var.app_name}-codebuild"
  role   = aws_iam_role.codebuild.id
  policy = data.aws_iam_policy_document.codebuild.json
}
