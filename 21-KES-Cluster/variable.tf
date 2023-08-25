variable "awsRegion" {
  type    = string
  default = "ap-south-1"
}
variable "key_name" {
  type    = string
  default = "my-eky"
}
variable "prefix" {
  default = "CompanyName"
}
variable "project" {
  default = "PACEOS20"
}
variable "contact" {
  default = "gudduray90@gmail.com"
}

locals {
  prefix           = "${var.prefix} - ${terraform.workspace}"
  environment      = terraform.workspace
  eks_cluster_name = terraform.workspace
  project          = var.project
  common_tags = {
    environment   = terraform.workspace
    role          = terraform.workspace
    project       = var.project
    owner         = var.contact
    appname       = var.project
    bussinessunit = var.project
    managedby     = "Terraform"

  }
}