##########################
##  ecs task role
##########################
data "aws_iam_policy_document" "ecs_task_assumerole" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task" {
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      values   = ["ecs-tasks.amazonaws.com"]
      variable = "iam:PassedToService"
    }
  }
}

resource "aws_iam_role" "ecs_task" {
  name               = "${var.app_name}-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assumerole.json
}

resource "aws_iam_role_policy" "ecs_task" {
  name   = "${var.app_name}-ecs-task"
  role   = aws_iam_role.ecs_task.id
  policy = data.aws_iam_policy_document.ecs_task.json
}

##########################
##  ecs task execute role
##########################
data "aws_iam_policy_document" "ecs_task_execution_assumerole" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_execution" {
  statement {
    effect    = "Allow"
    actions   = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.app_name}-ecs-task-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assumerole.json
}

resource "aws_iam_role_policy" "ecs_task_execution" {
  name   = "${var.app_name}-ecs-task-execution"
  role   = aws_iam_role.ecs_task_execution.id
  policy = data.aws_iam_policy_document.ecs_task_execution.json
}

##########################
##  ecs cluster
##########################
resource "aws_ecs_cluster" "main" {
  name               = "${var.app_name}-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE"]
}

##########################
##  ecs service
##########################
data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.main.family
}

resource "aws_ecs_service" "main" {
  name                              = "${var.app_name}-service"
  cluster                           = aws_ecs_cluster.main.id
  task_definition                   = "${aws_ecs_task_definition.main.family}:${max(aws_ecs_task_definition.main.revision, data.aws_ecs_task_definition.main.revision)}"
  launch_type                       = "FARGATE"
  desired_count                     = 1
  health_check_grace_period_seconds = 360

  load_balancer {
    target_group_arn = aws_lb_target_group.green.arn
    container_name   = var.app_name
    container_port   = 80
  }

  network_configuration {
    subnets          = [
      aws_subnet.public["ap-northeast-1a"].id,
      aws_subnet.public["ap-northeast-1c"].id
    ]

    security_groups  = [aws_security_group.service.id]
    assign_public_ip = true
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    ignore_changes = [
      health_check_grace_period_seconds,
      task_definition,
      load_balancer,
      desired_count
    ]
  }

  depends_on                        = [
    aws_lb_target_group.green
  ]
}

##########################
##  ecs task definition
##########################
resource "aws_ecs_task_definition" "main" {
  family                   = "${var.app_name}-family"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn
  cpu                      = "256"
  memory                   = "512"

  requires_compatibilities = ["FARGATE"]

  container_definitions    = data.template_file.container_def.rendered
}

data "template_file" "container_def" {
  template = file("./container_def.tpl")

  vars     = {
    container_name     = var.app_name
    ecr_repository_url = aws_ecr_repository.main.repository_url
    log_group          = aws_cloudwatch_log_group.ecs_task_definitions.name
  }
}


##########################
##  with ecs
##########################
resource "aws_ecr_repository" "main" {
  name                 = var.app_name
  image_tag_mutability = "MUTABLE"
}

resource "aws_cloudwatch_log_group" "ecs_task_definitions" {
  name = "/ecs/${var.app_name}"
}

resource "aws_security_group" "service" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.app_name}-service"
  description = "${var.app_name}-service"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}