variable "gcp_project" {
  description = "The GCP project id"
}

variable "location" {
  description = "GCP bucket location"
}

variable "labels" {
  description = "Labels used in all resources"
  type        = map(string)
  #   default = {
  #     manager = "terraform"
  #     team    = "TEAM"
  #     slack   = "talk-TEAM"
  #     app     = "SERVICE"
  #   }
  default     = {}

  validation {
    condition     = length(var.labels.app) != 0 && can(regex("^[^A-Z\\s]*$", var.labels.app))
    error_message = "The label 'app' is required and missing or empty or has not valid characters like uppercase or whitespace. Please specify the name of the application this resource belongs to (e.g. 'my-app')."
  }
   validation {
    condition     = length(var.labels.team) != 0 && can(regex("^[^A-Z\\s]*$", var.labels.team))
    error_message = "The label 'team' is required and missing or empty. Please specify the name of the team who maintains this resource (e.g. 'team-foo')."
  }
  validation {
    condition     = length(var.labels.slack) != 0 && can(regex("^[^A-Z\\s]*$", var.labels.slack))
    error_message = "The label 'slack' is required and missing or empty. Please specify a valid Slack channel where maintainers can be reached (e.g. '#talk-team')."
  }
  validation {
    condition     = length(var.labels.manager) != 0 && can(regex("^[^A-Z\\s]*$", var.labels.manager))
    error_message = "The label 'manager' is required and missing or empty. Please add a valid label which describes how this resource is managed (e.g. 'terraform')."
  }

}

variable "kubernetes_namespace" {
  description = "Your kubernetes namespace"

  validation {
    condition = (
      length(var.kubernetes_namespace) > 1 && can(regex("^[^A-Z\\s]*$", var.kubernetes_namespace))
    )
    error_message = "The length of kubernetes_namespace is not longer than 5 characters long or it has unvalid characters, like spaces or uppercase letters."
  }
  
}

variable "force_destroy" {
  description = "(Optional, Default: false) When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run"
  default     = false
}

variable "storage_class" {
  description = "GCP storage class"
  default     = "REGIONAL"
}

variable "versioning" {
  description = "The bucket's Versioning configuration."
  default     = "true"
}

variable "log_bucket" {
  description = "The bucket's Access & Storage Logs configuration"
  default     = "false"
}

variable "bucket_policy_only" {
  description = "Enables Bucket Policy Only access to a bucket"
  default     = "false"
}

variable "service_account_bucket_role" {
  description = "Role of the Service Account - more about roles https://cloud.google.com/storage/docs/access-control/iam-roles"
  default     = "roles/storage.objectViewer"
}

variable "prevent_destroy" {
  description = "Prevent destruction of bucket"
  type        = bool
  default     = false
}

variable "account_id" {
  description = "Bucket service account id override (empty string = use standard convention)"
  default     = ""
}

variable "account_id_use_existing" {
  description = "Set this to true if you want to use an existing service account, otherwise a new one will be created (account_id must also be provided if set to true)"
  default     = false
}

variable "bucket_instance_custom_name" {
  description = "Bucket instance name override (empty string = use standard convention)"
  default     = ""

#if we have a bucket_instance_custom_name it must be longer than x characters, and cannot contain spaces or uppercase letters.
  validation {
    condition = (
      ((length(var.bucket_instance_custom_name) == 0) ? true : ((length(var.bucket_instance_custom_name) > 5)) && can(regex("^[^A-Z\\s]*$", var.bucket_instance_custom_name)))
    )
    error_message = "The length of bucket_instance_custom_name is not longer than 5 characters long or it has unvalid characters, like spaces or uppercase letters ."
  }
}

variable "service_account_email" {
  description= "Email to the service account that we want the bucket to be attached to"
  default = ""
}