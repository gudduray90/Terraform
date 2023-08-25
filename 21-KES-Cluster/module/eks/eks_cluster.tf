resource "aws_eks_cluster" "main" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.EKS_Cluster_Role.arn
  version  = var.eks_cluster_version

  vpc_config {
    security_group_ids = ["${aws_security_group.sg_eks_cluster.id}"]
    subnet_ids         = ["${module.vpc.Public_Subnet}"]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = merge(
    {
      "Name" = var.eks_cluster_name
    }, local.common_tags
  )

  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_cluster_policy,
    aws_iam_role_policy_attachment.aws_eks_service_policy
  ]
}