resource "aws_s3_bucket" "rds_backups" {
  bucket        = "${var.env}-${local.app_name_lowercase}-rds-backups"
  force_destroy = var.env == "production" ? false : true
  tags          = local.tags
}

resource "aws_ssm_parameter" "rds_backups_bucket" {
  name        = "/${local.app_name_lowercase}/${var.env}/RDS_BACKUPS_BUCKET"
  description = "Name of bucket used for RDS backups"
  type        = "SecureString"
  value       = aws_s3_bucket.rds_backups.id

  tags = local.tags
}

resource "aws_s3_bucket_acl" "rds_backups" {
  bucket = aws_s3_bucket.rds_backups.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "rds_backups" {
  bucket = aws_s3_bucket.rds_backups.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "rds_backups" {
  bucket = aws_s3_bucket.rds_backups.id
  versioning_configuration {
    status = "Enabled"
  }
}
