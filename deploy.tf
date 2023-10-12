resource "aws_codedeploy_app" "web" {
  name = "${var.env}-${var.application_name}-web"
}
resource "aws_codedeploy_deployment_config" "web" {
  deployment_config_name = "${var.env}-${var.application_name}-web-config"
  compute_platform       = "Server"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = var.env == "production" ? 1 : 0
  }
}

resource "aws_codedeploy_deployment_group" "web" {
  app_name               = aws_codedeploy_app.web.name
  deployment_group_name  = "${var.env}-${var.application_name}-web"
  service_role_arn       = aws_iam_role.deploy.arn
  autoscaling_groups     = [module.autoscale_group.autoscaling_group_name]
  deployment_config_name = aws_codedeploy_deployment_config.web.deployment_config_name

  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.web.name
    }
  }
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }
}
