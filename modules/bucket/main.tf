locals {
  generation       = format("%03d", var.generation)
  bucket_shortname = var.name_override != null ? var.name_override : var.init.app.id
  bucket_name      = "ent-gcs-${local.bucket_shortname}-${var.init.environment}-${local.generation}"
  log_bucket_name  = var.enable_access_logs ? "ent-gcs-${local.bucket_shortname}-${var.init.environment}-${local.generation}-access-logs" : ""
  config_map_name  = var.name_override != null ? "${var.init.app.name}-${var.name_override}-bucket" : "${var.init.app.name}-bucket"
  storage_purpose = {
    standard = {
      location      = var.init.is_production ? "EU" : "EUROPE-WEST1"
      storage_class = "STANDARD"
    }
  }
  default_lifecycle = {
    max_object_versions = {
      action = {
        type = "Delete"
      }
      condition = {
        with_state                 = "ARCHIVED"
        days_since_noncurrent_time = var.versioned_object_retention_days
      }
    }
  }
  offsite_backup_label = var.disable_offsite_backup && var.init.is_production ? { label_backup_offsite = false } : {} # Add the label for opt-out of offsite backup in prod environments when disable_offsite_backup is true
}

resource "google_storage_bucket" "main" {
  name          = local.bucket_name
  project       = var.init.app.project_id
  location      = local.storage_purpose[var.storage_purpose].location
  force_destroy = var.force_destroy
  storage_class = local.storage_purpose[var.storage_purpose].storage_class

  dynamic "logging" {
    for_each = var.enable_access_logs ? ["this"] : []
    content {
      log_bucket = local.log_bucket_name
    }
  }

  labels                      = merge(var.init.labels, local.offsite_backup_label)
  uniform_bucket_level_access = true

  versioning {
    enabled = var.versioning
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules_override != null ? var.lifecycle_rules_override : local.default_lifecycle
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = try(lifecycle_rule.value.action.storage_class, null)
      }
      condition {
        age                        = try(lifecycle_rule.value.condition.age, null)
        created_before             = try(lifecycle_rule.value.condition.created_before, null)
        with_state                 = try(lifecycle_rule.value.condition.with_state, null)
        matches_storage_class      = try(lifecycle_rule.value.condition.matches_storage_class, null)
        num_newer_versions         = try(lifecycle_rule.value.condition.num_newer_versions, null)
        custom_time_before         = try(lifecycle_rule.value.condition.custom_time_before, null)
        days_since_custom_time     = try(lifecycle_rule.value.condition.days_since_custom_time, null)
        days_since_noncurrent_time = try(lifecycle_rule.value.condition.days_since_noncurrent_time, null)
        noncurrent_time_before     = try(lifecycle_rule.value.condition.noncurrent_time_before, null)
      }
    }
  }
}

resource "kubernetes_config_map" "main" {
  count = var.create_kubernetes_resources ? 1 : 0
  metadata {
    name      = local.config_map_name
    namespace = var.init.app.name
    labels    = var.init.labels
  }

  data = {
    BUCKET_NAME = google_storage_bucket.main.name
    BUCKET_URL  = google_storage_bucket.main.url
  }
}

