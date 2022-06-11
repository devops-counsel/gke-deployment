provider "google-beta" {
  region      = "us-central1"
}
resource "google_container_cluster" "demo-cluster" {
  name                  = "demo-cluster"
  project		= "devops-counsel-demo"
  location              = "us-central1-a"
  network               = google_compute_network.vpc_network.id
  subnetwork            = google_compute_subnetwork.subnet-1.id
  remove_default_node_pool = true
  min_master_version    = "1.22.8-gke.201"
  initial_node_count       = 1
  ip_allocation_policy {
    cluster_secondary_range_name = "k8s-pods"
    services_secondary_range_name = "k8s-services"
  }
}

resource "google_container_node_pool" "demo-gke-node-pool" {
  provider	     = google-beta
  project	     = "devops-counsel-demo"
  name               = "demo-gke-node-pool"
  location           = "us-central1-a"
  cluster            = google_container_cluster.demo-cluster.name
  initial_node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 1
  }

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    spot = true
    disk_size_gb = 10
    disk_type = "pd-standard"
  }
}
