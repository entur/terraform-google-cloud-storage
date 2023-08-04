output "cloud_storage_bucket_url" {
  value       = module.cloud-storage.cloud_storage_bucket.url
  description = "The cloud storage bucket url."
}
