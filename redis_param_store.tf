resource "aws_ssm_parameter" "redis_url" {
  name        = "/${local.app_name_lowercase}/${var.env}/REDIS_URL"
  description = "Connection string used by rails app to connect to redis"
  type        = "SecureString"
  value       = "rediss://${aws_elasticache_replication_group.web_app.primary_endpoint_address}:6379"

  tags = local.tags
}
