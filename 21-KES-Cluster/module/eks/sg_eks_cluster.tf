resource "aws_security_group" "sg_eks_cluster" {
  name        = var.sg_eks_cluster
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = var.sg_eks_cluster
    }, local.common_tags
  )
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_eks_cluster.id
  source_security_group_id = aws_security_group.sg_eks_cluster.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_eks_cluster.id
  source_security_group_id = aws_security_group.sg_eks_cluster.id
  to_port                  = 65535
  type                     = "egress"
}
