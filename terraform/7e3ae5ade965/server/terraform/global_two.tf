##########################
##  two ecs target_group
##########################
resource "aws_lb_target_group" "two_blue" {
  name        = "${replace(var.app_name_two, "_", "-")}-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  health_check {
    protocol            = "HTTP"
    path                = "/public/two/health.html"
    interval            = 60
    timeout             = 30
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  depends_on  = [aws_lb.main]
}

resource "aws_lb_target_group" "two_green" {
  name        = "${replace(var.app_name_two, "_", "-")}-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  health_check {
    protocol            = "HTTP"
    path                = "/public/two/health.html"
    interval            = 60
    timeout             = 30
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  depends_on  = [aws_lb.main]
}

##########################
##  two ecs listener_rule
##########################
resource "aws_lb_listener_rule" "two" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.two_green.arn
  }

  condition {
    path_pattern {
      values = ["*/two/*"]
    }
  }
}