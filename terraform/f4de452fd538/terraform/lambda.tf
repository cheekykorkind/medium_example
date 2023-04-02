# Lambda
data "archive_file" "lambda_map_source" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/map_source"
  output_path = "${path.module}/lambda/zips/map_source.zip"
}
resource "aws_lambda_function" "map_source" {
  function_name = "${var.app_name}-map"
  role          = aws_iam_role.lambda_role.arn

  filename         = data.archive_file.lambda_map_source.output_path
  source_code_hash = data.archive_file.lambda_map_source.output_base64sha256

  handler     = "app.lambda_handler"
  runtime     = "python3.9"
  timeout     = 60
  memory_size = 512
}

data "archive_file" "lambda_map_task" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/map_task"
  output_path = "${path.module}/lambda/zips/map_task.zip"
}
resource "aws_lambda_function" "map_task" {
  function_name = "${var.app_name}-task"
  role          = aws_iam_role.lambda_role.arn

  filename         = data.archive_file.lambda_map_task.output_path
  source_code_hash = data.archive_file.lambda_map_task.output_base64sha256

  handler     = "app.lambda_handler"
  runtime     = "python3.9"
  timeout     = 60
  memory_size = 512
}

data "archive_file" "lambda_map_result" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/map_result"
  output_path = "${path.module}/lambda/zips/map_result.zip"
}
resource "aws_lambda_function" "map_result" {
  function_name = "${var.app_name}-result"
  role          = aws_iam_role.lambda_role.arn

  filename         = data.archive_file.lambda_map_result.output_path
  source_code_hash = data.archive_file.lambda_map_result.output_base64sha256

  handler     = "app.lambda_handler"
  runtime     = "python3.9"
  timeout     = 60
  memory_size = 512
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
