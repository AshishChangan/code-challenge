terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.47.0" # pinning version
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.43.0"
    }
  }
}

provider "google" {
  credentials = file("cred.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}
provider "google-beta" {
  region  = var.region
  project = var.project_id
}

backend "gcs" {
   bucket  = "BUCKET_NAME"
   prefix  = "terraform/state"
 }
