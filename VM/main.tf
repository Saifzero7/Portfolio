
resource "google_compute_network" "custom_vpc" {
  name = "gke-custom-vpc"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-us-central1"
  region        = "us-central1"
  network       = google_compute_network.custom_vpc.self_link
  ip_cidr_range = "172.16.0.0/20"
}

resource "google_compute_instance" "jenkins_instance" {
  name         = "jenkins-instance"
  machine_type = var.machine_type
  zone         = "us-central1-a"
  tags         = ["jenkins"]

  boot_disk {
    initialize_params {
      image = var.boot_image
    }
  }

  network_interface {
    network = google_compute_network.custom_vpc.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y default-jre
    sudo apt-get install -y wget
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt-get update
    sudo apt-get install -y jenkins
  EOF
}

resource "google_compute_firewall" "jenkins_firewall" {
  name    = "allow-jenkins-traffic"
  network = google_compute_network.custom_vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["8080", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["jenkins"]
}