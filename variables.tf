variable "aws_region" {
  type        = string
  default     = "eu-west-2"
  description = "AWS region to deploy all resources"
}

variable "user_name" {
  type        = string
  default     = "hashicorp"
  description = "Username for EKS cluster administration"
}

variable "enable_consul_and_vault" {
  type        = bool
  default     = false
  description = "Enable consul and vault for the secrets cluster"
}
