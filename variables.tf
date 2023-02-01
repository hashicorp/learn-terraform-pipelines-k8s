variable "region" {
  type        = string
  default     = "us-central1"
  description = "GCP region to deploy clusters."
}

variable "cluster_name" {
  type        = string
  default     = "tfc-pipelines"
  description = "Name of cluster."
}

variable "enable_consul_and_vault" {
  type        = bool
  default     = false
  description = "Enable consul and vault for the secrets cluster"
}
