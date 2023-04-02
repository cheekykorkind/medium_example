resource "aws_sfn_state_machine" "sfn" {
  name     = "${var.app_name}-state-machine"
  role_arn = aws_iam_role.sfn_role.arn
  
  type     = "STANDARD"
  definition = jsonencode({
    "StartAt" : "map_source",
    "States" : {
      "map_source" : {
        "Type" : "Task",
        "Resource" : "arn:aws:states:::lambda:invoke",
        "OutputPath" : "$.Payload",
        "Parameters" : {
          "Payload.$" : "$",
          "FunctionName" : "${aws_lambda_function.map_source.arn}:$LATEST"
        },
        "Next" : "Map"
      },
      "Map" : {
        "Type" : "Map",
        "ItemProcessor" : {
          "ProcessorConfig" : {
            "Mode" : "INLINE"
          },
          "StartAt" : "map_task",
          "States" : {
            "map_task" : {
              "Type" : "Task",
              "Resource" : "arn:aws:states:::lambda:invoke",
              "OutputPath" : "$.Payload",
              "Parameters" : {
                "Payload.$" : "$",
                "FunctionName" : "${aws_lambda_function.map_task.arn}:$LATEST"
              },
              "End" : true
            }
          }
        },
        "MaxConcurrency" : 3,
        "Next" : "map_result"
      },
      "map_result" : {
        "Type" : "Task",
        "Resource" : "arn:aws:states:::lambda:invoke",
        "OutputPath" : "$.Payload",
        "Parameters" : {
          "Payload.$" : "$",
          "FunctionName" : "${aws_lambda_function.map_result.arn}:$LATEST"
        }
        "End" : true
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
          aws_lambda_function.map_source.arn,
          aws_lambda_function.map_task.arn,
          aws_lambda_function.map_result.arn,
          "${aws_lambda_function.map_source.arn}:*",
          "${aws_lambda_function.map_task.arn}:*",
          "${aws_lambda_function.map_result.arn}:*"
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "sfn_role_attachment" {
  role       = aws_iam_role.sfn_role.name
  policy_arn = aws_iam_policy.sfn_lambda_invoke.arn
}