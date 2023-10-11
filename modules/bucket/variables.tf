variable "enable_access_logs" {
  description = "Set to true to enable access logs, log bucket will have bucket name appended with 'access-logs'. Bucket 'ent-gcs-foo-dev-001' will have access logs in bucket 'ent-gcs-foo-dev-001-access-logs'"
  default     = false
}

variable "init" {
  description = "Entur init module output. https://github.com/entur/terraform-gcp-init. Used to determine application name, application project, labels, and resource names."
  type = object({
    app = object({
      id         = string
      name       = string
      owner      = string
      project_id = string
    })
    environment   = string
    labels        = map(string)
    is_production = bool
  })
}

variable "name_override" {
  description = "Set to override the default bucket name. Follows contentions; setting it to 'foo' in dev will result in the bucket being named 'ent-gcs-foo-dev-001' (<prefix>-<var.name_override>-<env>-<generation>). Is also applied to the name of the Kubernetes config map."
  type        = string
  default     = null
}

#variable "location" {
#  description = "The location of the Cloud Storage bucket. Can be a region ('EUROPE-WEST1'), dual-region('EUROPE-WEST1+EUROPE-WEST4'), or multi-region('EU')."
#  type        = string
#  default     = "EUROPE-WEST1"
#  validation {
#    condition     = can(regex("^(EU$|EUROPE-[A-Z1-9]+)", var.location))
#    error_message = "Cloud storage location must be in Europe, and in the form EU, EUROPE-WEST1 or EUROPE-WEST1+EUROPE-WEST4."
#  }
#}

#variable "storage_class" {
#  description = "The Cloud Storage storage class. Supported values: STANDARD, NEARLINE, COLDLINE, ARCHIVE."
#  type        = string
#  default     = "STANDARD"
#}

variable "generation" {
  description = "The generation (aka serial no.) of the instance. Starts at 1, ends at 999. Will be padded with leading zeros."
  type        = number
  default     = 1

  validation {
    condition     = var.generation < 1000 && var.generation > 0
    error_message = "Generation must be between [1,999]."
  }
}

variable "force_destroy" {
  description = "Whether to allow Terraform to delete the bucket even if it contains objects."
  type        = bool
  default     = false
}

variable "storage_purpose" {
  description = "The purpose of the storage bucket. Determines storage class, retention and geo-redundancy. Supported values: 'standard'."
  type        = string
  default     = "standard"
}

variable "disable_offsite_backup" {
  description = "Disable offsite backup of the bucket. Offsite backup is only applied to production environments."
  type        = bool
  default     = false
}

variable "versioning" {
  description = "Whether to enable object versioning."
  type        = bool
  default     = true
}

variable "versioned_object_retention_days" {
  description = "The number of days to keep old versions of changed or deleted files. Only takes effect if 'versioning' is enabled (default), and 'lifecycle_rule_override' is not used. NOTE: This parameter might have a large impact on cost depending on bucket use."
  type        = number
  default     = 2
}

variable "lifecycle_rules_override" {
  description = "The bucket's Lifecycle Rules configuration (advanced). Will override the 'versioned_object_retention_days' setting."
  type = map(object({
    action = object({
      type = string
    })
    condition = map(string)
  }))
  default = null
  validation {
    condition     = var.lifecycle_rules_override == null || can([for rule in var.lifecycle_rules_override : rule.action.type != null && rule.condition != null])
    error_message = "Every lifecycle rule must have an 'action.type', and contain a 'condition', or be 'null'."
  }
}

variable "create_kubernetes_resources" {
  description = "Whether to create a Kubernetes config map containing the bucket name and URL."
  type        = bool
  default     = true
}