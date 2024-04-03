terraform {
  backend "gcs" {
    bucket      = "project-gke-deployment"
    prefix      = "terraform/terraform.tfstate"
    credentials = "gke-creds.json"
  }
}