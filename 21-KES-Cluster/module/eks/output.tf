output "autoscaling_id" {
  value = aws_eks_node_group.main.resources[*].autoscaling_groups[0].name
}

output "spot_autoscaling_id" {
  value = aws_eks_node_group.spot.resources[*].autoscaling_groups[0].name
}