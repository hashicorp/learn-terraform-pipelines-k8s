output "cluster" {
  value = google_container_cluster.engineering.name
}

output "host" {
  value     = google_container_cluster.engineering.endpoint
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = base64decode(google_container_cluster.engineering.master_auth.0.cluster_ca_certificate)
  sensitive = true
}

output "client_certificate" {
  value     = base64decode(google_container_cluster.engineering.master_auth.0.client_certificate)
  sensitive = true
}

output "client_key" {
  value     = base64decode(google_container_cluster.engineering.master_auth.0.client_key)
  sensitive = true
}

output "project_id" {
  value = google_container_cluster.engineering.project
}

output "region" {
  value = data.google_compute_zones.available.region
}
