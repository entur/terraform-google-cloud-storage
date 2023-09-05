variable "init" {
  default = {
    app = {
      id         = "tfmodules"
      name       = "terraform-modules"
      owner      = "team-plattform"
      project_id = "ent-tfmodules-dev"
    }
    environment = "dev"
    labels = {
      app    = "terraform-modules"
      app_id = "tfmodules"
      env    = "dev"
      team   = "team-plattform"
      owner  = "team-plattform"
    }
    is_production = false
  }
}

variable "generation" {
  default = 1
}

variable "name_override" {
  description = "Set to override the default bucket name. Follows contentions; setting it to 'foo' in dev will result in the bucket being named 'ent-gcs-foo-dev-001' (<prefix>-<var.name_override>-<env>-<generation>). Is also applied to the name of the Kubernetes config map."
  type        = string
  default     = null
}
