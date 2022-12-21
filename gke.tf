data "google_compute_zones" "available" {}

resource "google_container_cluster" "engineering" {
  name     = var.cluster_name
  location = data.google_compute_zones.available.names.0

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {}
}

resource "google_container_node_pool" "engineering_preemptible_nodes" {
  name     = "${var.cluster_name}-node-pool"
  cluster  = google_container_cluster.engineering.name
  location = data.google_compute_zones.available.names.0

  node_count = var.enable_consul_and_vault ? 5 : 3

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/kubeconfig-template.yaml")

  vars = {
    cluster_name    = google_container_cluster.engineering.name
    user_name       = google_container_cluster.engineering.master_auth[0].username
    user_password   = google_container_cluster.engineering.master_auth[0].password
    endpoint        = google_container_cluster.engineering.endpoint
    cluster_ca      = google_container_cluster.engineering.master_auth[0].cluster_ca_certificate
    client_cert     = google_container_cluster.engineering.master_auth[0].client_certificate
    client_cert_key = google_container_cluster.engineering.master_auth[0].client_key
  }
}
