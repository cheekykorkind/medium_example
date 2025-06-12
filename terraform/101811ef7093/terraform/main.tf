resource "aws_sqs_queue" "dead_letter_queue" {
  name                      = "${var.app_name}-dead-letter-queue"
  message_retention_seconds = 60 * 60 * 24 * 14
}

resource "aws_sqs_queue" "main_queue" {
  name = "${var.app_name}-main-queue"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_queue.arn
    maxReceiveCount     = 2
  })
}

resource "aws_iam_role" "iot_rule_role" {
  name = "${var.app_name}-iot-rule-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "iot.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "iot_rule_policy" {
  name = "${var.app_name}-iot-rule-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = "sqs:SendMessage",
      Effect   = "Allow",
      Resource = aws_sqs_queue.main_queue.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "iot_rule_attach" {
  role       = aws_iam_role.iot_rule_role.name
  policy_arn = aws_iam_policy.iot_rule_policy.arn
}

resource "aws_iot_topic_rule" "iot_to_sqs" {
  name    = "${var.app_name}_iot_to_sqs_rule"
  enabled = true

  sql         = "SELECT * FROM 'mqtt/topic/test'"
  sql_version = "2016-03-23"

  sqs {
    queue_url  = aws_sqs_queue.main_queue.url
    role_arn   = aws_iam_role.iot_rule_role.arn
    use_base64 = false
  }

  error_action {
    cloudwatch_logs {
      log_group_name = "/aws/iot/rules/${var.app_name}"
      role_arn       = aws_iam_role.iot_rule_role.arn
    }
  }
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.21.0"

  function_name = "${var.app_name}-processor"
  handler       = "app.handler"
  runtime       = "python3.13"
  architectures = ["arm64"]
  memory_size   = 128
  source_path   = "./py"

  attach_policy_json = true
  policy_json = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Action" : ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"],
      "Effect" : "Allow",
      "Resource" : aws_sqs_queue.main_queue.arn
    }]
  })

  event_source_mapping = {
    sqs = {
      event_source_arn        = aws_sqs_queue.main_queue.arn
      function_response_types = ["ReportBatchItemFailures"]
      batch_size              = 10
      scaling_config = {
        maximum_concurrency = 10
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "dlq_alarm" {
  alarm_name          = "${var.app_name}-dlq-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Sum"
  threshold           = 1

  dimensions = {
    QueueName = aws_sqs_queue.dead_letter_queue.name
  }
}
