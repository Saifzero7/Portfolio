provider "google" {
  credentials = file("gke-creds.json")
  project     = "test-env-417010"
  region      = "us-central1"
}