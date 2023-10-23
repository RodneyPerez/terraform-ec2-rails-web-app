resource "aws_s3_bucket" "pipeline" {
  bucket        = "${var.env}-${local.app_name_lowercase}-pipeline-bucket"
  force_destroy = var.env == "production" ? false : true

  tags = local.tags
}

resource "aws_s3_bucket_public_access_block" "pipeline" {
  bucket = aws_s3_bucket.pipeline.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

