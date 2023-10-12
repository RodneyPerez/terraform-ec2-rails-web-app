module "alb_http_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "http-alb-${var.env}"
  description = "Used for alb in ${var.env}"
  vpc_id      = data.aws_vpc.selected.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "alb_https_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/https-443"

  name        = "https-alb-${var.env}"
  description = "Used for alb in ${var.env}"
  vpc_id      = data.aws_vpc.selected.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_lb" "alb" {
  name               = "${var.env}-${var.application_name}-web"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups = [
    module.alb_http_sg.security_group_id,
    module.alb_https_sg.security_group_id
  ]

  enable_deletion_protection = var.env == "production" ? true : false
  tags                       = local.tags
}

