resource "aws_elasticache_replication_group" "web_app" {
  automatic_failover_enabled = false
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  replication_group_id       = "${var.env}-${var.application_name}-redis-group"
  description                = "${var.env} ${var.application_name} redis group"
  node_type                  = "cache.t3.medium"
  num_cache_clusters         = 1
  engine                     = "redis"
  engine_version             = "5.0.6"
  parameter_group_name       = "default.redis5.0"
  security_group_ids         = [aws_security_group.redis.id]
  port                       = 6379
}
resource "aws_security_group" "redis" {
  name        = "${var.env}_${local.underscore_app_name}_redis_allow_app"
  description = "Allow only inbound traffic from application"
  vpc_id      = data.aws_vpc.selected.id
  tags        = local.tags
}
resource "aws_security_group_rule" "redis_egress_allow_all" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.redis.id
}
resource "aws_security_group_rule" "redis_app_ingress" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web.id
  security_group_id        = aws_security_group.redis.id
}
