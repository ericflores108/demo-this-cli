terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = "demoed-454102"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_storage_bucket" "demoed" {
  name = "demoed108"
  location = "US"
  force_destroy = true
}

resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.demoed.name
  role = "READER"
  entity = "allUsers"
}

resource "google_project_iam_custom_role" "uploader_role" {
  role_id     = "storageUploader"
  title       = "Storage Uploader"
  description = "Allows uploading objects to the storage bucket"
  permissions = [
    "storage.objects.create",
    "storage.objects.delete",
    "storage.objects.update",
    "storage.objects.get"
  ]
}

resource "google_storage_bucket_iam_binding" "uploaders_binding" {
  bucket = google_storage_bucket.demoed.name
  role   = "projects/demoed-454102/roles/storageUploader"

  members = [
    "user:eflorty108@gmail.com"
  ]
}