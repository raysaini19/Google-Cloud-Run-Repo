resource "google_vpc_access_connector" "cloud_run_connector" {
  name = "cloud-run-vpc"
  subnet {
    name = google_compute_subnetwork.cloud_run_vpc_subnet.name
  }
  # machine_type  = "e2-micro"
  # min_instances = 2
  # max_instances = 3
  region  = var.region
  project = var.project_id
}

resource "google_compute_subnetwork" "cloud_run_vpc_subnet" {
  name          = "cloud-run-subnetwork"
  ip_cidr_range = "10.128.0.0/28"
  region        = var.region
  project       = var.project_id
  network       = google_compute_network.cloud_run_vpc_network.id
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_network" "cloud_run_vpc_network" {
  name                    = "cloud-run-network"
  auto_create_subnetworks = false
  project                 = var.project_id
}