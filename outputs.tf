output "aws_region" {
  description = "AWS region for all resources"
  value       = var.aws_region
}

output "cluster" {
  description = "Name of the EKS cluster"
  value       = data.aws_eks_cluster.cluster.id
}

output "endpoint" {
  description = "URL of the kubernetes endpoint"
  value       = data.aws_eks_cluster.cluster.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "EKS cluster's CA certificate"
  value       = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  sensitive   = true
}

output "enable_consul_and_vault" {
  description = "Boolean flag to enable consul and vault"
  value       = var.enable_consul_and_vault
}

# Does not require aws-iam-authenticator
output "kubeconfig" {
  description = "Kubeconfig file for cluster management"
  value       = data.template_file.kubeconfig.rendered
  sensitive   = true
}

# Requires aws-iam-authenticator
output "module_kubeconfig" {
  description = "Kubeconfig file for cluster management"
  value       = module.eks_cluster.kubeconfig
  sensitive   = true
}

output "config_map_aws_auth" {
  description = "Config map for AWS auth"
  value       = module.eks_cluster.config_map_aws_auth
}
