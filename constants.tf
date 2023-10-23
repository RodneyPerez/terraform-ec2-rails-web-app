locals {
  #tags used on all resources deployed with this plan
  tags = {
    "Environment" : var.env,
    "Application" : "Main Web ${local.application_title_name}",
    "terraform" : true
  }
  application_repo       = var.repo
  application_org        = var.org
  application_title_name = title(replace(var.application_name, "-", " "))
  underscore_app_name    = replace(var.application_name, "-", "_")
  app_name_lowercase     = lower(var.application_name)
}
