terraform {
  # backend "remote" {
  #   organization = "hashicorp-learn"
  #   workspaces {
  #     name = "learn-terraform-pipelines-k8s"
  #   }
  # }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.34.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.3"
    }
  }

  required_version = "~> 0.14"
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  cluster_name = "education-eks-${random_string.suffix.result}"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.66.0"

  name                 = "education-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}

module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "14.0.0"

  cluster_version = "1.19"
  cluster_name    = local.cluster_name

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  tags = {
    Environment = "training"
  }

  worker_groups = [
    {
      name                          = "worker-group-one"
      instance_type                 = "t2.micro"
      root_volume_type              = "gp2"
      asg_desired_capacity          = 3
      asg_max_size                  = 5
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks_cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_id
}

# Does not require aws-iam-authenticator
data "template_file" "kubeconfig" {
  template = file("${path.module}/kubeconfig-template.yaml")

  vars = {
    cluster_name = data.aws_eks_cluster.cluster.id
    endpoint     = data.aws_eks_cluster.cluster.endpoint
    cluster_ca   = data.aws_eks_cluster.cluster.certificate_authority[0].data
    user_name    = var.user_name
    aws_region   = var.aws_region
  }
}

# The Kubernetes provider is included in this file so the EKS module can
# complete successfully. Otherwise, it throws an error when creating
# `kubernetes_config_map.aws_auth`. This configuration does not provision
# any kubernetes resources on the EKS cluster.
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}
