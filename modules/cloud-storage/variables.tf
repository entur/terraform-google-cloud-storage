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
  description = "A name override for Cloud Storage buckets resulting in a name on the form 'ent-gcs-<name_override>-<env>-<generation>'. Using the name_override will also add the name to the generated Kubernetes configmap."
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
  description = "Generation of the Cloud Storage bucket. Starts at 1, ends at 999. Will be padded with leading zeros."
  type        = number
  default     = 1

  validation {
    condition     = var.generation < 1000 && var.generation > 0
    error_message = "Generation must be bewteen [1,999]."
  }
}

variable "force_destroy" {
  description = "Whether to allow terraform to delete the bucket if it contains objects."
  type        = bool
  default     = false
}

variable "storage_purpose" {
  description = "The purpose of the Cloud Storage storage class. Determines storage class and geo redundancy. Supported values: 'standard', 'archive'."
  type        = string
  default     = "standard"
}

variable "versioning" {
  description = "Set to true to enable object versioning."
  type        = bool
  default     = true
}

variable "versioned_object_retention_days" {
  description = "The number of days to keep old versions of changed or deleted files. Only takes effect if lifecycle_rule_override is not used. NOTE: This parameter might have a large impact on cost depending bucket usage."
  type        = number
  default     = 7
}

variable "lifecycle_rules_override" {
  description = "Object lifecycle rules used to operate on objects based on conditions."
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
