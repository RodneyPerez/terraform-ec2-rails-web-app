module "autoscale_group" {
  source = "git::https://github.com/cloudposse/terraform-aws-ec2-autoscale-group.git?ref=0.30.0"

  name = "${var.env}-${var.application_name}-Web"

  image_id                    = data.aws_ami.web_app.id
  instance_type               = "t2.medium"
  security_group_ids          = [aws_security_group.web.id]
  subnet_ids                  = data.aws_subnets.default.ids
  health_check_type           = "EC2"
  min_size                    = var.env == "production" ? 2 : 1
  max_size                    = 5
  wait_for_capacity_timeout   = "5m"
  associate_public_ip_address = true
  iam_instance_profile_name   = aws_iam_instance_profile.web_app_web.id
  key_name                    = var.key_pair_name
  target_group_arns           = [aws_lb_target_group.web.arn]
  user_data_base64            = data.cloudinit_config.config.rendered

  tags = local.tags

  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = "true"
  cpu_utilization_high_threshold_percent = "70"
  cpu_utilization_low_threshold_percent  = "20"
}
