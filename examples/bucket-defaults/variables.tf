variable "gcp_project" {
  description = "The GCP project id"
}

variable "location" {
  description = "GCP bucket location"
}

variable "labels" {
  description = "Labels used in all resources"
  type        = map(string)
  default = {
    manager = "terraform"
    team    = "teamname"
    slack   = "talk-teamname"
    app     = "my-app"
  }
}

variable "kubernetes_namespace" {
  description = "Your kubernetes namespace"
  default     = "default"
}

variable "prevent_destroy" {
  description = "Prevent destruction of bucket"
  type        = bool
  default     = false
}

variable "service_account_email" {
  description = "Email to the service account that we want the bucket to be attached to"
  default     = ""
}
