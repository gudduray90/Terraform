resource "aws_eks_node_group" "spot" {
  cluster_name    = var.eks_cluster_name
  node_group_name = var.eks_spot_nodegroup_name
  node_role_arn   = aws_iam_role.eks_workernodes_roles.arn
  subnet_ids      = var.public_subnet_ids
  capacity_type   = "SPOT"
  ami_type        = var.ami_type
  disk_size       = var.disk_size
  instance_types  = var.spot_instance_types

  remote_access {
    ec2_ssh_key = var.ssh_key_name
  }

  scaling_config {
    desired_size = var.spot_desired_node_size
    max_size     = var.spot_max_node_size
    min_size     = var.spot_min_node_size
  }

  tags = merge(
    {
      Name = var.eks_spot_nodegroup_name
    }, local.common_tags
  )

  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_read_only
  ]
}