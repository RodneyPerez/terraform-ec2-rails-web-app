resource "aws_security_group_rule" "lb_ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.alb_https_sg.security_group_id
  security_group_id        = aws_security_group.web.id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group" "web" {
  name        = "${var.env}_${local.underscore_app_name}_allow_lb"
  description = "Allow inbound traffic from load balancer"
  vpc_id      = data.aws_vpc.selected.id
  tags        = local.tags
}

