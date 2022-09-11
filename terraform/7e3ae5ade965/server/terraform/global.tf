resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
}

resource "aws_subnet" "public" {
  for_each          = {
    "ap-northeast-1a" = 1
    "ap-northeast-1c" = 2
  }
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, each.value)
  availability_zone = each.key
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "web_1_a" {
  subnet_id      = aws_subnet.public["ap-northeast-1a"].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "web_1_c" {
  subnet_id      = aws_subnet.public["ap-northeast-1c"].id
  route_table_id = aws_route_table.public.id
}

resource "aws_lb" "main" {
  name                       = "${replace(var.app_name, "_", "-")}"
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false

  security_groups            = [aws_security_group.lb.id]

  subnets                    = [
    aws_subnet.public["ap-northeast-1a"].id,
    aws_subnet.public["ap-northeast-1c"].id
  ]
}

resource "aws_security_group" "lb" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.app_name}-alb"
  description = "${var.app_name}-alb"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "blue" {
  name        = "${replace(var.app_name, "_", "-")}-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  health_check {
    protocol            = "HTTP"
    path                = "/public/one/health.html"
    interval            = 60
    timeout             = 30
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  depends_on  = [aws_lb.main]
}

resource "aws_lb_target_group" "green" {
  name        = "${replace(var.app_name, "_", "-")}-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  health_check {
    protocol            = "HTTP"
    path                = "/public/one/health.html"
    interval            = 60
    timeout             = 30
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  depends_on  = [aws_lb.main]
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

  lifecycle {ignore_changes = [default_action]}
}