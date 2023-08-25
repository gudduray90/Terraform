resource "aws_eks_node_group" "main" {
  cluster_name    = var.eks_cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_workernodes_roles.arn
  subnet_ids      = var.public_subnet_ids

  ami_type       = var.ami_type
  disk_size      = var.disk_size
  instance_types = var.nodegroup_instance_types

  remote_access {
    ec2_ssh_key = var.ssh_key_name
  }

  scaling_config {
    desired_size = var.nodegroup_desired_node_size
    max_size     = var.nodegroup_max_node_size
    min_size     = var.nodegroup_min_node_size
  }

  tags = merge(
    {
      Name = var.node_group_name
    }, local.common_tags
  )

  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_read_only
  ]
}