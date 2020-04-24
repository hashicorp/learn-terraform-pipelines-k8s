terraform {
  backend "remote" {
    organization = "hashicorp-team-da-beta"

    workspaces {
      name = "qa-kubernetes-cluster"
    }
  }
}

provider "google" {
  version = "3.10.0"
  project = var.google_project
  region  = var.location.gcp
}