variable "eks_cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
}
variable "eks_cluster_version" {
  type        = string
  description = "EKS cluster version"
}
variable "security_group_ids" {
  type = list(string)
}
variable "subnet_ids" {
  type = list(string)
}
variable "eks_spot_nodegroup_name" {
  type        = string
  description = "Name of the spot nodegroup"
}
variable "public_subnet_ids" {
  type        = string
  description = "List of subnet ids"
}
variable "ami_type" {
  type        = string
  default     = "AL2_x86_64"
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to AL2_x86_64. Valid values: AL2_x86_64, AL2_x86_64_GPU."
}
variable "disk_size" {
  type        = string
  description = "Disk Size in GiB for Worker Node"
  default     = "100"
}
variable "spot_instance_types" {
  type        = list(string)
  default     = ["t3.xlarge", "t3a.large", "t2.large", "m5a.large", "m5ad.large"]
  description = "Set of instance types associated with the EKS Spot Node Group."
}

variable "nodegroup_instance_types" {
  type        = list(string)
  default     = ["t3.xlarge"]
  description = "Set of instance types associated with the EKS Node Group."
}
variable "ssh_key_name" {
  type        = string
  description = "SSH Pem Key Name for Worker Node"
}
variable "spot_desired_node_size" {
  type        = string
  default     = 1
  description = "Spot node desired ec2 instance size"
}
variable "spot_max_node_size" {
  type        = string
  default     = 1
  description = "Spot node max ec2 instance size"
}
variable "spot_min_node_size" {
  type        = string
  default     = 1
  description = "Spot node min ec2 instance size"
}
variable "node_group_name" {
  type        = string
  description = "Worker Node group Name"
}
variable "nodegroup_desired_node_size" {
  type        = string
  default     = 1
  description = "Nodegroup node desired ec2 instance size"
}
variable "nodegroup_max_node_size" {
  type        = string
  default     = 1
  description = "Nodegroup node max ec2 instance size"
}
variable "nodegroup_min_node_size" {
  type        = string
  default     = 1
  description = "Nodegroup node min ec2 instance size"
}
variable "sg_eks_cluster" {
  type        = string
  description = "EKS Cluster Security group Name"
}
variable "vpc_id" {
  type        = string
  description = "VPC ID for creating EKS cluster worker node"
}
variable "sg_workernode_name" {
  type        = string
  description = "Security Group Name for worker NodeGroup"
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
