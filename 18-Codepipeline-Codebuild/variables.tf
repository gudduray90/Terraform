variable "githubConnection" {
  type = string
}

variable "S3Bucket" {
  type = string
}

variable "providerType" {
  type = string
}

variable "accesskey" {
  type = string
}

variable "secretkey" {
  type = string
}

variable "awsregion" {
  type = string
}

variable "codepipeline-name" {
  type = string
}

variable "github-repo" {
  type = string
}

variable "github-barnch" {
  type = string
}

variable "build_projects" {
  type = list(string)
}

variable "project_name" {
  type = string
}

variable "build_project_source" {
  description = "Information about the build output artifact location"
  type        = string
}

variable "builder_compute_type" {
  description = "Information about the compute resources the build project will use"
  type        = string
}

variable "builder_image" {
  description = "Docker image to use for the build project"
  type        = string
}

variable "builder_type" {
  description = "Type of build environment to use for related builds"
  type        = string
}

variable "github_personal_access_token" {
  type = string
}