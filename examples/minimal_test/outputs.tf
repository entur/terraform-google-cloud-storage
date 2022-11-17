output "cloud_storage_bucket" {
  value       = module.cloud-storage.cloud_storage_bucket
  description = "The cloud storage bucket output, as described in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket."
}
