variable "location" {
  type        = map
  description = "Map containing provider and the region to deploy clusters."
  default = {
    gcp = "us-central1"
  }
}

variable "cluster_provider" {
  type        = string
  default     = "gke"
  description = "Cluster provider, can be gke or do"
}

variable "cluster_name" {
  type        = string
  description = "Name of cluster."
}

variable "google_project" {
  type        = string
  description = "Google Project to deploy cluster"
}

variable "username" {
  type        = string
  default     = "admin"
  description = "Username for GKE clusters"
}

variable "password" {
  type        = string
  description = "Password for GKE clusters"
}

variable "enable_consul_and_vault" {
  type        = bool
  default     = false
  description = "Enable consul and vault for the secrets cluster"
}