locals {
  project     = var.project_settings.project
  region      = var.project_settings.aws_region
  name_prefix = var.project_settings.project


  policies = "${path.root}/policies"

  scripts = "${path.root}/scripts"


}
