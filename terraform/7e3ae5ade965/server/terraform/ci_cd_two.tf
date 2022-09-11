##########################
##  two ecs deployment_group
##########################
resource "aws_codedeploy_deployment_group" "two" {
  deployment_group_name  = var.app_name_two
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  app_name               = aws_codedeploy_app.main.name
  service_role_arn       = aws_iam_role.cd_service_role.arn
  
  auto_rollback_configuration {
    enabled = true
    events  = [
      "DEPLOYMENT_FAILURE"
    ]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.main.name # cluster는 같은걸 써서 괜찮다
    service_name = aws_ecs_service.two.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [
          aws_lb_listener.main.arn # listener는 같은걸 써서 괜찮다
        ]
      }
      target_group {
        name = aws_lb_target_group.two_blue.name
      }
      target_group {
        name = aws_lb_target_group.two_green.name
      }
    }
  }
}