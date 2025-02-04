resource "azurerm_role_assignment" "staging-api_sb_role" {
  scope                = data.terraform_remote_state.base_state.outputs.base_sb_queue_ordertoexecute_id
  role_definition_name = "Azure Service Bus Data Sender"
  principal_id         = module.container_apps_ingress.container_app_identities["staging-api"].principal_id
}

resource "azurerm_role_assignment" "staging-outboxmon_sb_role" {
  scope                = data.terraform_remote_state.base_state.outputs.base_sb_queue_ordertoexecute_id
  role_definition_name = "Azure Service Bus Data Sender"
  principal_id         = module.container_apps_no_ingress.container_app_identities["staging-outboxmon"].principal_id
}

resource "azurerm_role_assignment" "staging-orderrec_sb_send_role" {
  scope                = data.terraform_remote_state.base_state.outputs.base_sb_queue_ordertoexecute_id
  role_definition_name = "Azure Service Bus Data Sender"
  principal_id         = module.container_apps_no_ingress.container_app_identities["staging-orderrec"].principal_id
}

resource "azurerm_role_assignment" "staging-order_sb_send_role" {
  scope                = data.terraform_remote_state.base_state.outputs.base_sb_subscription_ocstaging_id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = module.container_apps_no_ingress.container_app_identities["staging-orderrec"].principal_id
}