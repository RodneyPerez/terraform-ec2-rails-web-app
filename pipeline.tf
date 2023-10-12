resource "aws_codestarconnections_connection" "github_connection" {
  name          = "${var.env}-${var.application_name}-connection"
  provider_type = "GitHub"
}
resource "aws_codepipeline" "codepipeline" {
  name     = "${var.env}-${var.application_name}-web"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.pipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["code"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github_connection.arn
        FullRepositoryId = "${local.application_org}/${local.application_repo}"
        BranchName       = var.branch
      }
    }
  }
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["code"]
      version         = "1"

      configuration = {
        "ApplicationName"     = aws_codedeploy_app.web.name
        "DeploymentGroupName" = aws_codedeploy_deployment_group.web.deployment_group_name
      }
    }
  }
}

