##########################
##  ecs service
##########################
data "aws_ecs_task_definition" "two" {
  task_definition = aws_ecs_task_definition.two.family
}

resource "aws_ecs_service" "two" {
  name                              = "${var.app_name_two}-service"
  cluster                           = aws_ecs_cluster.main.id # cluster는 같은걸 써서 괜찮다
  task_definition                   = "${aws_ecs_task_definition.two.family}:${max(aws_ecs_task_definition.two.revision, data.aws_ecs_task_definition.two.revision)}"
  launch_type                       = "FARGATE"
  desired_count                     = 1
  health_check_grace_period_seconds = 360

  load_balancer {
    target_group_arn = aws_lb_target_group.two_green.arn
    container_name   = var.app_name_two
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
      load_balancer
    ]
  }

  depends_on                        = [
    aws_lb_target_group.green
  ]
}

##########################
##  ecs task definition
##########################
resource "aws_ecs_task_definition" "two" {
  family                   = "${var.app_name_two}-family"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn
  cpu                      = "256"
  memory                   = "512"

  requires_compatibilities = ["FARGATE"]

  container_definitions    = data.template_file.container_def_two.rendered
}

data "template_file" "container_def_two" {
  template = file("./container_def.tpl")

  vars     = {
    container_name     = var.app_name_two
    ecr_repository_url = aws_ecr_repository.main.repository_url # docker이미지는 같은걸 써서 괜찮다
    log_group          = aws_cloudwatch_log_group.ecs_task_definitions.name
  }
}


##########################
##  with ecs
##########################
resource "aws_cloudwatch_log_group" "two_ecs_task_definitions" {
  name = "/ecs/${var.app_name_two}"
}

resource "aws_security_group" "two_service" {
  vpc_id      = aws_vpc.main.id # vpc같은걸써서 괜찮다
  name        = "${var.app_name_two}-service"
  description = "${var.app_name_two}-service"

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