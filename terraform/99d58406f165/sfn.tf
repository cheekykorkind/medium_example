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
            "Mode" : "DISTRIBUTED",
            "ExecutionType" : "STANDARD"
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
        "ItemReader": {
          "Resource": "arn:aws:states:::s3:getObject",
          "ReaderConfig": {
            "InputType": "CSV",
            "CSVHeaderLocation": "FIRST_ROW"
          },
          "Parameters": {
            "Bucket.$": "$.sfn_bucket",
            "Key.$": "$.sfn_bucket_item_reader_key"
          }
        },
        "ResultWriter": {
          "Resource": "arn:aws:states:::s3:putObject",
          "Parameters": {
            "Bucket": aws_s3_bucket.sfn.id,
            "Prefix": "output"
          }
        },
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
      },

      # https://docs.aws.amazon.com/step-functions/latest/dg/iam-policies-eg-dist-map.html
      {
        Effect = "Allow",
        Action = [
          "states:StartExecution"
        ],
        Resource = [
          aws_sfn_state_machine.sfn.arn
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "states:DescribeExecution",
          "states:StopExecution"
        ],
        Resource = [
          "${aws_sfn_state_machine.sfn.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.sfn.arn
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListMultipartUploadParts",
          "s3:AbortMultipartUpload"
        ],
        Resource = [
          "${aws_s3_bucket.sfn.arn}*"
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "sfn_role_attachment" {
  role       = aws_iam_role.sfn_role.name
  policy_arn = aws_iam_policy.sfn_lambda_invoke.arn
}