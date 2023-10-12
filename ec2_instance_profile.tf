resource "aws_iam_instance_profile" "web_app_web" {
  name = "${var.env}_${local.underscore_app_name}_web"
  role = aws_iam_role.web_app_web.name
}

data "aws_iam_policy" "ssm_read" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}
data "aws_iam_policy" "cloudwatch_agent" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
data "aws_iam_policy" "ssm_agent" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role" "web_app_web" {
  name = "${var.env}-${var.application_name}-web"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = local.tags
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "*",
    ]
  }
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.main_app.bucket}/",
      "arn:aws:s3:::${aws_s3_bucket.pipeline.bucket}/",
    ]
  }
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.main_app.bucket}/*",
      "arn:aws:s3:::${aws_s3_bucket.pipeline.bucket}/*",
    ]
  }
}

resource "aws_iam_policy" "s3_access" {
  name   = "${var.env}EC2S3Access"
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.web_app_web.id
  policy_arn = aws_iam_policy.s3_access.arn
}
resource "aws_iam_role_policy_attachment" "ssm_read_only" {
  role       = aws_iam_role.web_app_web.id
  policy_arn = data.aws_iam_policy.ssm_read.arn
}
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.web_app_web.id
  policy_arn = data.aws_iam_policy.cloudwatch_agent.arn
}
resource "aws_iam_role_policy_attachment" "ssm_agent" {
  role       = aws_iam_role.web_app_web.id
  policy_arn = data.aws_iam_policy.ssm_agent.arn
}
