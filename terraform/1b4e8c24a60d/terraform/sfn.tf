resource "aws_cloudwatch_log_group" "express" {
  name = "/aws/vendedlogs/states/${var.app_name}-express"
}

resource "aws_sfn_state_machine" "sfn" {
  name     = "${var.app_name}-state-machine"
  role_arn = aws_iam_role.sfn_role.arn

  logging_configuration {
    # https://docs.aws.amazon.com/ko_kr/AWSCloudFormation/latest/UserGuide/aws-properties-stepfunctions-statemachine-cloudwatchlogsloggroup.html
    # The ARN must end with :*
    log_destination        = "${aws_cloudwatch_log_group.express.arn}:*"

    include_execution_data = true
    level                  = "ALL"
  }
  
  type     = "EXPRESS"
  definition = jsonencode({
    "StartAt": "lambda_invoke",
    "States": {
      "lambda_invoke": {
        "Type": "Task",
        "Resource": "arn:aws:states:::lambda:invoke",
        "OutputPath": "$.Payload",
        "Parameters": {
          "Payload.$": "$",
          "FunctionName": "${aws_lambda_function.lambda_task.arn}:$LATEST"
        },
        "End": true
      }
    }
  })
}


# SFN IAM Role
resource "aws_iam_role" "sfn_role" {
  name = "${var.app_name}-sfn"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "states.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_policy" "sfn_lambda_invoke" {
  name = "${var.app_name}-sfn"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction",
        ]
        Resource = [
          aws_lambda_function.lambda_task.arn,
          "${aws_lambda_function.lambda_task.arn}:*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogDelivery",
          "logs:GetLogDelivery",
          "logs:UpdateLogDelivery",
          "logs:DeleteLogDelivery",
          "logs:ListLogDeliveries",
          "logs:PutLogEvents",
          "logs:PutResourcePolicy",
          "logs:DescribeResourcePolicies",
          "logs:DescribeLogGroups"
        ]
        Resource = ["*"]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sfn_role_attachment" {
  role       = aws_iam_role.sfn_role.name
  policy_arn = aws_iam_policy.sfn_lambda_invoke.arn
}