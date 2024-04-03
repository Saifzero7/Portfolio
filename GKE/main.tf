
resource "google_container_cluster" "my_cluster" {
  name     = "my-gke-cluster"
  location = "us-central1"
  
  node_pool {
    name            = "default-pool"
    initial_node_count = 1

    autoscaling {
      min_node_count = 1
      max_node_count = 3
    }
  }

  node_config {
    machine_type = var.machine_types
    disk_size_gb = 100
    disk_type    = "pd-standard"
  }
}
