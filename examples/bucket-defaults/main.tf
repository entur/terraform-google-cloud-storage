
terraform {
  required_version = ">= 0.12"
}

module "gcp-init" {
  #source               = "../../modules/init"
  source               = "github.com/entur/terraform-gcp-init/modules/init"
  labels               = var.labels
  project_id           = var.gcp_project
  kubernetes_namespace = var.kubernetes_namespace
}

module "bucket" {

  #source = "github.com/entur/terraform//modules/bucket"
  source                      = "/mnt/c/Users/E180047/Documents/GitHub/terraform-gcp-bucket/modules/bucket"
  labels                      = var.labels
  gcp_project                 = var.gcp_project
  location                    = var.location
  kubernetes_namespace        = var.kubernetes_namespace
  storage_class               = "REGIONAL"
  service_account_bucket_role = "roles/storage.objectViewer"
  prevent_destroy             = var.prevent_destroy
  service_account_email       = module.gcp-init.service_account_email
}




#pls