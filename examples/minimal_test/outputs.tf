# output "cloud_storage_bucket" {
#   value       = module.cloud-storage.cloud_storage_bucket
#   description = "The cloud storage bucket output, as described in https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket."
# }

output "cloud_storage_bucket_url" {
  value       = module.cloud-storage.cloud_storage_bucket.url
  description = "The cloud storage bucket url."
}
