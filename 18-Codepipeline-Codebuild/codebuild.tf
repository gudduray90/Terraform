resource "aws_codebuild_project" "dev-sso-codebuild" {
  name = var.project_name
  #service_role   = aws_iam_role.codepipeline-role.arn
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }
  environment {
    compute_type                = var.builder_compute_type
    image                       = var.builder_image
    type                        = var.builder_type
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "GITHUB_PERSONAL_ACCESS_TOKEN"
      value = var.github_personal_access_token
    }

    environment_variable {
      name  = "ENVIRONMENT"
      value = "Development"
    }

  }
  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }
  source {
    type     = "GITHUB"
    location = "https://github.com/gudduray90/jenkinesproject2.git"
    #location = "https://github.com/gudduray90/jenkinesproject2/blob/master/bildspec-apply.yml"
    git_clone_depth = 1
    buildspec       = "bildspec-apply.yml"

    # auth {
    #   type = "OAUTH"
    #   #resource = aws_codebuild_source_credential.github_personal_access_token.arn
    #   resource = var.github_personal_access_token
    # }
    # git_submodules_config {
    #   fetch_submodules = true
    # }
  }
}