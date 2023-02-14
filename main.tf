terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.48.0"
    }
  }

  required_version = ">= 1.1.0"
}



provider "google" {
  project = var.google_project
  region  = var.region
}
