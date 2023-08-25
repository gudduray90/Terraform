output "autoscaling_id" {
  value = module.eks_cluster_and_worker_nodes.autoscaling_id
}

output "spot_autoscaling_id" {
  value = module.eks_cluster_and_worker_nodes.spot_autoscaling_id
}