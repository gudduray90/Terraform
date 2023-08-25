terraform {
  backend "s3" {
    bucket         = "ssoteknocodepipelinenew"
    key            = "paceos-devqa.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "paceapp-devops-tfstate-lock-test"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13.1"
    }
  }
}

provider "aws" {
  region = var.awsRegion
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc_for_eks" {
  source             = "./modules/vpc"
  availability_zones = data.aws_availability_zones.available.names
}


module "eks_cluster_and_worker_nodes" {
  source                 = "./modules/eks"
  eks_cluster_name       = local.eks_cluster_name
  environment            = local.environment
  key_name               = var.key_name
  cluster_sg_name        = "${local.environment}-cluster-sg"
  nodes_sg_name          = "${local.environment}-node-sg"
  vpc_id                 = module.vpc_for_eks.vpc_id
  eks_cluster_subnet_ids = module.vpc_for_eks.public_subnet_ids
  node_group_name        = "${local.eks_cluster_name}-node-group"
  spot_node_group_name   = "${local.eks_cluster_name}-spot-node-group"
  public_subnet_ids      = module.vpc_for_eks.public_subnet_ids
}


resource "null_resource" "add_custom_tags_to_asg" {
  triggers = {
    node_group = module.eks_cluster_and_worker_nodes.autoscaling_id[0]
  }
  provisioner "local-exec" {
    command = <<EOF
aws autoscaling create-or-update-tags \
  --tags ResourceId=${module.eks_cluster_and_worker_nodes.autoscaling_id[0]},ResourceType=auto-scaling-group,Key=Name,Value=${local.eks_cluster_name}-node-group,PropagateAtLaunch=true --region ap-south-1
EOF
  }
}

resource "null_resource" "add_custom_tags_to_spot_asg" {
  triggers = {
    node_group = module.eks_cluster_and_worker_nodes.spot_autoscaling_id[0]
  }
  provisioner "local-exec" {
    command = <<EOF
aws autoscaling create-or-update-tags \
  --tags ResourceId=${module.eks_cluster_and_worker_nodes.spot_autoscaling_id[0]},ResourceType=auto-scaling-group,Key=Name,Value=${local.eks_cluster_name}-spot-node-group,PropagateAtLaunch=true --region ap-south-1
EOF
  }
}