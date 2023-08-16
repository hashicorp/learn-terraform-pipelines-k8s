# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

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

variable "google_project" {
  type        = string
  description = "Google Project to deploy cluster"
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the node pool"
  default     = 3
}