variable "GOOGLE_CREDENTIALS" {
  description = "Path to the Google Cloud credentials file"
  type        = string
  default     = "/Users/josephobukofe/Documents/terrademo/keys/my-creds.json"
}

variable "project_id" {
  description = "The project ID of your Google Cloud Account"
  type        = string
  default     = "dtc-de-course-412523"
}

variable "location" {
  description = "The project location"
  type        = string
  default     = "US"
}

variable "my_google_bigquery_dataset" {
  description = "My BigQuery dataset name"
  type        = string
  default     = "demo_dataset"
}

variable "my_google_storage_bucket" {
  description = "My storage bucket name"
  type        = string
  default     = "dtc-de-course-412523-terraform-demo-bucket"
}