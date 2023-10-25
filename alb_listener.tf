resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_target_group" "web" {
  name                 = "${var.env}-${var.application_name}-web-tg"
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 10
  vpc_id               = data.aws_vpc.selected.id
  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 10
    path                = var.healthcheck_path
    matcher             = var.healthcheck_status_code
    interval            = 6
    timeout             = 5
  }
}
