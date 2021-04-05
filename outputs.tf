output "aws_region" {
  description = "AWS region for all resources"
  value       = var.aws_region
}

output "cluster" {
  description = "Name of the EKS cluster"
  value       = data.aws_eks_cluster.cluster.id
}

output "enable_consul_and_vault" {
  description = "Boolean flag to enable consul and vault"
  value       = var.enable_consul_and_vault
}