resource "aws_iam_role" "codepipeline_role" {
  name = "${var.env}_${local.underscore_app_name}_pipeline_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl"
      ],
      "Resource": [
				"${aws_s3_bucket.pipeline.arn}",
        "${aws_s3_bucket.pipeline.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
				"codedeploy:CreateDeployment",
        "codedeploy:GetApplicationRevision",
        "codedeploy:GetDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:RegisterApplicationRevision"
      ],
      "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": "codestar-connections:UseConnection",
        "Resource": "${aws_codestarconnections_connection.github_connection.arn}"
    }
  ]
}
EOF
}
