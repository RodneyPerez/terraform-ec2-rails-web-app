resource "aws_ssm_parameter" "rails_master_key" {
  name        = "/${local.app_name_lowercase}/${var.env}/RAILS_MASTER_KEY"
  description = "Master key used in rails application to be able to start"
  type        = "SecureString"
  value       = var.rails_master_key

  tags = local.tags
}

resource "aws_ssm_parameter" "RAILS_ENV" {
  name        = "/${local.app_name_lowercase}/${var.env}/RAILS_ENV"
  description = "Rails env used to start application"
  type        = "SecureString"
  value       = var.rails_env

  tags = local.tags
}
