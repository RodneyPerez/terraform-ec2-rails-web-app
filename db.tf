locals {
  db_instance_map = {
    "production" : "db.m5.large"
  }
}
resource "aws_db_instance" "main_db" {
  identifier                      = "${var.env}-${local.app_name_lowercase}-web"
  db_name                         = var.db_name
  allocated_storage               = 20
  storage_type                    = "gp2"
  engine                          = "mysql"
  engine_version                  = "5.7"
  instance_class                  = lookup(local.db_instance_map, terraform.workspace, "db.t2.small")
  username                        = var.db_username
  password                        = random_string.db_password.result
  storage_encrypted               = true
  publicly_accessible             = true
  vpc_security_group_ids          = [aws_security_group.db.id]
  parameter_group_name            = aws_db_parameter_group.main.name
  skip_final_snapshot             = var.env == "production" ? false : true
  final_snapshot_identifier       = "${var.env}-final-${var.application_name}-web-snapshot"
  deletion_protection             = true
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  monitoring_interval             = 30
  monitoring_role_arn             = aws_iam_role.main_db_monitoring.arn
  option_group_name               = aws_db_option_group.main.name
  maintenance_window              = "Sat:09:00-Sat:11:00"
  backup_retention_period         = 7
  backup_window                   = "07:00-08:50"
  copy_tags_to_snapshot           = true
}

resource "aws_iam_role" "main_db_monitoring" {
  name = "${var.env}-${var.application_name}-db-monitoring-role"


  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy" "main_db_monitoring" {
  name = "AmazonRDSEnhancedMonitoringRole"
}

resource "aws_iam_role_policy_attachment" "main_db" {
  role       = aws_iam_role.main_db_monitoring.name
  policy_arn = data.aws_iam_policy.main_db_monitoring.arn
}

resource "aws_db_option_group" "main" {
  name                     = "${var.env}-${local.app_name_lowercase}-web"
  option_group_description = "Option group for main Mysql database"
  engine_name              = "mysql"
  major_engine_version     = "5.7"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"

    option_settings {
      name  = "SERVER_AUDIT_EVENTS"
      value = "CONNECT,QUERY"
    }
  }
}

resource "aws_db_parameter_group" "main" {
  name   = "${var.env}-${local.app_name_lowercase}-web"
  family = "mysql5.7"

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "general_log"
    value = "1"
  }
  parameter {
    name  = "long_query_time"
    value = "2"
  }
  parameter {
    name  = "log_output"
    value = "FILE"
  }

}

resource "random_string" "db_password" {
  length  = 25
  special = false
}

resource "aws_security_group_rule" "db_allow_all" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db.id
}

resource "aws_security_group_rule" "app_ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web.id
  security_group_id        = aws_security_group.db.id
}
resource "aws_security_group_rule" "approved_db_ingress" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = var.access_ips
  security_group_id = aws_security_group.db.id
}
resource "aws_security_group" "db" {
  name        = "${var.env}_${local.underscore_app_name}_allow_app"
  description = "Allow only inbound traffic from application"
  vpc_id      = data.aws_vpc.selected.id
  tags        = local.tags
}
