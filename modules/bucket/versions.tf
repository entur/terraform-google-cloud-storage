terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.26.0"
    },
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
  }
  required_version = ">=0.13.2"
}
