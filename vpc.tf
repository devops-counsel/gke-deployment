resource "google_compute_network" "vpc_network" {
  name = "devops-counsel-vpc"
  auto_create_subnetworks = false
  project = "devops-counsel-demo"
}
resource "google_compute_subnetwork" "subnet-1" {
  name          = "devops-counsel-subnet-1"
  ip_cidr_range = "172.16.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
  secondary_ip_range {
    range_name    = "k8s-pods"
    ip_cidr_range = "172.22.0.0/16"
  }
  secondary_ip_range {
    range_name    = "k8s-services"
    ip_cidr_range = "172.16.2.0/24"
  }
}
resource "google_compute_subnetwork" "subnet-2" {
  name          = "devops-counsel-subnet-2"
  ip_cidr_range = "172.16.3.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  project = "devops-counsel-demo"
  network = google_compute_network.vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "allow-internal" {
  name    = "allow-internal"
  project = "devops-counsel-demo"
  network = google_compute_network.vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }
  allow {
  protocol = "udp"
    ports    = ["1-65535"]
  }
   allow {
  protocol = "icmp"
  }
  source_ranges = ["172.16.0.0/24", "172.16.1.0/24", "172.16.2.0/24" ]
}
