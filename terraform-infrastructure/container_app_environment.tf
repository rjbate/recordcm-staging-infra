/*
resource "random_id" "rg_name" {
  byte_length = 8
}

resource "random_id" "env_name" {
  byte_length = 8
}

resource "random_id" "container_name" {
  byte_length = 4
}

locals {
  counting_app_name = "counting-${random_id.container_name.hex}"
  #dashboard_app_name = "dashboard-${random_id.container_name.hex}"
}
*/

/*
resource "azurerm_user_assigned_identity" "acr_pull" {
  name                = "${var.record_env}-acrpull-identity"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  tags = merge(local.env_tag, var.common_tags)
}

resource "azurerm_role_assignment" "acr_pull_role" {
  scope                = data.terraform_remote_state.shared_state.outputs.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.acr_pull.principal_id
}
*/

module "container_apps_no_ingress" {

  #source = "git::https://----PAT----@dev.azure.com/recordcm/Record/_git/terraform-azure-container-apps-module?ref=terraform_pinning"

  source = "git@github.com:rjbate/terraform-azure-container-apps-module.git?ref=terraform_pinning_2024072202"
  #N.B. the source is pinned to a commit tag to avoid surprises
  #This works because an RSA private key is placed in the DevOps Pipeline Library Secure Files section

  resource_group_name            = data.azurerm_resource_group.example.name
  location                       = data.azurerm_resource_group.example.location
  container_app_environment_name = data.terraform_remote_state.shared_state.outputs.aca_env_name

  container_app_environment = {
    name                = data.terraform_remote_state.shared_state.outputs.aca_env_name
    resource_group_name = data.terraform_remote_state.shared_state.outputs.aca_env_rg
  }

  container_apps = var.container_apps_no_ingress
  common_tags    = merge(local.env_tag, var.common_tags)
  record_env     = var.record_env
  acr_pull_id    = data.terraform_remote_state.base_state.outputs.base_acr_pull_id

  log_analytics_workspace = data.terraform_remote_state.shared_state.outputs.laws_workspace

  #depends_on = [
  #  azurerm_role_assignment.acr_pull_role
  #]
}

module "container_apps_ingress" {

  #source = "git::https://----PAT----@dev.azure.com/recordcm/Record/_git/terraform-azure-container-apps-module?ref=terraform_pinning"

  source = "git@github.com:rjbate/terraform-azure-container-apps-module.git?ref=terraform_pinning_2024072202"
  #N.B. the source is pinned to a commit tag to avoid surprises
  #This works because an RSA private key is placed in the DevOps Pipeline Library Secure Files section

  resource_group_name            = data.azurerm_resource_group.example.name
  location                       = data.azurerm_resource_group.example.location
  container_app_environment_name = data.terraform_remote_state.shared_state.outputs.aca_env_name

  container_app_environment = {
    name                = data.terraform_remote_state.shared_state.outputs.aca_env_name
    resource_group_name = data.terraform_remote_state.shared_state.outputs.aca_env_rg
  }

  container_apps = var.container_apps_ingress
  common_tags    = merge(local.env_tag, var.common_tags)
  record_env     = var.record_env
  acr_pull_id    = data.terraform_remote_state.base_state.outputs.base_acr_pull_id

  log_analytics_workspace = data.terraform_remote_state.shared_state.outputs.laws_workspace

  #depends_on = [
  #  azurerm_role_assignment.acr_pull_role
  #]
}

/*
module "container_apps_no_ingress_peered" {

  #source = "git::https://----PAT----@dev.azure.com/recordcm/Record/_git/terraform-azure-container-apps-module?ref=terraform_pinning"

  source = "git@github.com:rjbate/terraform-azure-container-apps-module.git?ref=terraform_pinning_2024072202"
  #N.B. the source is pinned to a commit tag to avoid surprises
  #This works because an RSA private key is placed in the DevOps Pipeline Library Secure Files section

  resource_group_name            = data.azurerm_resource_group.example.name
  location                       = data.azurerm_resource_group.example.location
  container_app_environment_name = data.terraform_remote_state.shared_state.outputs.aca_env_name_peered

  container_app_environment = {
    name                = data.terraform_remote_state.shared_state.outputs.aca_env_name_peered
    resource_group_name = data.terraform_remote_state.shared_state.outputs.aca_env_rg_peered
  }

  container_apps = var.container_apps_no_ingress_peered
  common_tags    = merge(local.env_tag, var.common_tags)
  record_env     = var.record_env
  acr_pull_id    = azurerm_user_assigned_identity.acr_pull.id

  log_analytics_workspace = data.terraform_remote_state.shared_state.outputs.laws_workspace

  depends_on = [
    azurerm_role_assignment.acr_pull_role
  ]
}

module "container_apps_ingress_peered" {

  #source = "git::https://----PAT----@dev.azure.com/recordcm/Record/_git/terraform-azure-container-apps-module?ref=terraform_pinning"

  source = "git@github.com:rjbate/terraform-azure-container-apps-module.git?ref=terraform_pinning_2024072202"
  #N.B. the source is pinned to a commit tag to avoid surprises
  #This works because an RSA private key is placed in the DevOps Pipeline Library Secure Files section

  resource_group_name            = data.azurerm_resource_group.example.name
  location                       = data.azurerm_resource_group.example.location
  container_app_environment_name = data.terraform_remote_state.shared_state.outputs.aca_env_name_peered

  container_app_environment = {
    name                = data.terraform_remote_state.shared_state.outputs.aca_env_name_peered
    resource_group_name = data.terraform_remote_state.shared_state.outputs.aca_env_rg_peered
  }

  container_apps = var.container_apps_ingress_peered
  common_tags    = merge(local.env_tag, var.common_tags)
  record_env     = var.record_env
  acr_pull_id    = azurerm_user_assigned_identity.acr_pull.id

  log_analytics_workspace = data.terraform_remote_state.shared_state.outputs.laws_workspace

  depends_on = [
    azurerm_role_assignment.acr_pull_role
  ]
}
*/
