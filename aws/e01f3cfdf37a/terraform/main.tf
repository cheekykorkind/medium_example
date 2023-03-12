# S3
resource "aws_s3_bucket" "s-t-j" {
  bucket = "${var.app_name}-bucket"
}
resource "aws_s3_bucket_acl" "s-t-j" {
  bucket = aws_s3_bucket.s-t-j.id
  acl    = "private"
}
resource "aws_s3_bucket_public_access_block" "s-t-j" {
  bucket                  = aws_s3_bucket.s-t-j.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ECR
resource "aws_ecr_repository" "s-t-j" {
  name = "${var.app_name}-repo"
}

# IAM for SageMaker training job
data "aws_iam_policy_document" "sagemaker_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "sagemaker-training" {
  name               = "${var.app_name}-role"
  assume_role_policy = data.aws_iam_policy_document.sagemaker_assume_role_policy.json
}
resource "aws_iam_role_policy_attachment" "sagemaker-training-exec" {
  role       = aws_iam_role.sagemaker-training.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}