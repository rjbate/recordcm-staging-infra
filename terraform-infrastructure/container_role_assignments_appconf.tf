resource "azurerm_role_assignment" "staging-outboxmon_appconf_role" {
  scope                = azurerm_app_configuration.example.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = module.container_apps_no_ingress.container_app_identities["staging-outboxmon"].principal_id
}

resource "azurerm_role_assignment" "staging-orderrec_appconf_role" {
  scope                = azurerm_app_configuration.example.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = module.container_apps_no_ingress.container_app_identities["staging-orderrec"].principal_id
}

resource "azurerm_role_assignment" "staging-api_appconf_role" {
  scope                = azurerm_app_configuration.example.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = module.container_apps_ingress.container_app_identities["staging-api"].principal_id
}