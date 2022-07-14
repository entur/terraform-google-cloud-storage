output "init" {
  value       = var.init
  description = "The init module used in the module."
}

output "cloud_storage_bucket" {
  value       = google_storage_bucket.main
  description = "The cloud storage bucket output, as described in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket."
}
