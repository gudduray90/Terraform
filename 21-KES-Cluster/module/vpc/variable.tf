variable "accesskey" {}
variable "secretkey" {}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block range for vpc"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "CIDR block range for the private subnets"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "CIDR block range for the public subnets"
}

variable "sunbet_availability_zones" {
  type        = list(string)
  description = "availability zones for the selected region"
}
variable "prefix" {
  type    = string
  default = "CompanyName"
}
variable "contact" {
  type    = string
  default = "Guddu Kumar Ray"
}
variable "project" {
  type    = string
  default = "ProjectName"
}

locals {
  type             = "map"
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