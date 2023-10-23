resource "aws_s3_bucket" "main_app" {
  bucket = "${var.env}-${local.app_name_lowercase}-web-app"

  force_destroy = var.env == "production" ? false : true

  tags = local.tags
}

resource "aws_ssm_parameter" "paperclip_bucket" {
  name        = "/${local.app_name_lowercase}/${var.env}/PAPERCLIP_BUCKET"
  description = "Name of bucket used for storage"
  type        = "SecureString"
  value       = aws_s3_bucket.main_app.id

  tags = local.tags
}


resource "aws_s3_bucket_public_access_block" "main_app" {
  bucket = aws_s3_bucket.main_app.id

  block_public_acls       = var.public_paperclip_bucket ? false : true
  block_public_policy     = var.public_paperclip_bucket ? false : true
  ignore_public_acls      = var.public_paperclip_bucket ? false : true
  restrict_public_buckets = var.public_paperclip_bucket ? false : true

}

resource "aws_s3_bucket_versioning" "main_app" {
  bucket = aws_s3_bucket.main_app.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "allow_public_access" {
  count = var.public_paperclip_bucket ? 1 : 0

  bucket = aws_s3_bucket.main_app.id
  policy = data.aws_iam_policy_document.allow_public_access.json
}

data "aws_iam_policy_document" "allow_public_access" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.main_app.arn}/*",
    ]
  }
}
