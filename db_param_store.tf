resource "aws_ssm_parameter" "db_url" {
  name        = "/${local.app_name_lowercase}/${var.env}/DATABASE_URL"
  description = "Connection string used by rails app to connect to database"
  type        = "SecureString"
  value       = "mysql2://${var.db_username}:${aws_db_instance.main_db.password}@${aws_db_instance.main_db.endpoint}/${var.db_name}"

  tags = local.tags
}

resource "aws_ssm_parameter" "db_name" {
  name        = "/${local.app_name_lowercase}/${var.env}/DATABASE_NAME"
  description = "The database name for ${var.env} RDS"
  type        = "SecureString"
  value       = var.db_name

  tags = local.tags
}

resource "aws_ssm_parameter" "db_endpoint" {
  name        = "/${local.app_name_lowercase}/${var.env}/DATABASE_ENDPOINT"
  description = "The database endpoint for ${var.env} RDS"
  type        = "SecureString"
  value       = aws_db_instance.main_db.address

  tags = local.tags
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/${local.app_name_lowercase}/${var.env}/DATABASE_PASSWORD"
  description = "The database Password for ${var.env} RDS"
  type        = "SecureString"
  value       = aws_db_instance.main_db.password

  tags = local.tags
}

resource "aws_ssm_parameter" "db_username" {
  name        = "/${local.app_name_lowercase}/${var.env}/DATABASE_USER"
  description = "The database User for ${var.env} RDS"
  type        = "SecureString"
  value       = var.db_username

  tags = local.tags
}
