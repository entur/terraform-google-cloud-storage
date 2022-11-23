resource "random_integer" "random_revision_generation" {
  min = 1
  max = 999
}

module "init" {
  source      = "github.com/entur/terraform-google-init//modules/init?ref=v0.3.0"
  app_id      = "tfmodules"
  environment = "dev"
}

module "cloud-storage" {
  source = "../../../modules/bucket"
  init   = module.init
  generation = var.generation != null ? var.generation : random_integer.random_revision_generation.result
  name_override = var.name_override != null ? var.name_override : var.init.app.id
}
