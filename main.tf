terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.13.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = "us-central1"
  credentials = var.GOOGLE_CREDENTIALS
}

resource "google_storage_bucket" "demo-bukcet" { # <- Referring to the variable (identifiable) name for the bucket resource
  name          = var.my_google_storage_bucket   # <- Referring to the actual bucket we want to provision in our infrastructure
  location      = var.location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "demo-dataset" { # <- Referring to the variable (identifiable) name for the dataset resource
  dataset_id = var.my_google_bigquery_dataset       # <- Referring to the actual name of the bigquery dataset
  location   = var.location
}