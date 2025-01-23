resource "azurerm_user_assigned_identity" "example" {
  name                = "${var.record_env}-kv-identity"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  tags = merge(local.env_tag, var.common_tags)
}

/*
resource "azurerm_key_vault" "example" {
  name                       = "${var.record_env}-${var.azure_devops_project_target}-kv-00"
  location                   = data.azurerm_resource_group.example.location
  resource_group_name        = data.azurerm_resource_group.example.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  tags = merge(local.env_tag, var.common_tags)
}

resource "azurerm_key_vault_access_policy" "server" {
  key_vault_id = azurerm_key_vault.example.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.example.principal_id
  #The above is the object_id of the UAMI this TF file generates

  key_permissions    = ["Get", "UnwrapKey", "WrapKey"]
  secret_permissions = ["Get", "List"]

  #tags = merge(local.env_tag, var.common_tags)
}

resource "azurerm_key_vault_access_policy" "client" {
  key_vault_id = azurerm_key_vault.example.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  #object_id    = data.azurerm_client_config.current.object_id
  object_id = "ee54d0f3-4f4f-485e-b1ff-d799aba666e0"

  #####
  #
  # THIS IS NOT QUITE KOSHER - it is ARBITRARY
  #
  # The above is the object_id of ca-rbate
  # retrieved via 'az ad signed-in-user show --query id -o tsv'
  # Leaving it the original, commented out way could authorise the creating PIPELINE, vs the user.
  #
  #####

  key_permissions    = ["Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify", "GetRotationPolicy"]
  secret_permissions = ["Get", "List"]

  #tags = merge(local.env_tag, var.common_tags)
}

resource "azurerm_key_vault_access_policy" "pipeline_client" {
  key_vault_id = azurerm_key_vault.example.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  #object_id    = data.azurerm_client_config.current.object_id
  object_id = var.env_top_level_uami
  #The above is the object_id of the recordcm-record-dev UAMI
  #Dump this into tfvars - it will not change a lot - RJB - 05062024
  #(only with a totally new run from the OIDC initial setup)
  #These identities are essentially immutable

  #This is done to enable Terraform to assess the state of the .... state ?!

  key_permissions    = ["Get", "List", "GetRotationPolicy"]
  secret_permissions = ["Get", "List"]

  #tags = merge(local.env_tag, var.common_tags)
}

resource "azurerm_key_vault_key" "example" {
  name         = "${var.record_env}-kv-key"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 4096
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  tags = merge(local.env_tag, var.common_tags)

  depends_on = [
    azurerm_key_vault_access_policy.client,
    azurerm_key_vault_access_policy.server,
  ]
}
*/

resource "azurerm_app_configuration" "example" {
  name                     = "${var.record_env}-${var.azure_devops_project_target}-appConf-00"
  resource_group_name      = data.azurerm_resource_group.example.name
  location                 = data.azurerm_resource_group.example.location
  sku                      = "standard"
  local_auth_enabled       = true
  public_network_access    = "Enabled"
  purge_protection_enabled = false
  #soft_delete_retention_days = 1

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.example.id,
    ]
  }

  encryption {
    key_vault_key_identifier = data.terraform_remote_state.base_state.outputs.base_kv_key
    #key_vault_key_identifier = azurerm_key_vault_key.example.id
    identity_client_id = azurerm_user_assigned_identity.example.client_id
  }

  tags = merge(local.env_tag, var.common_tags)

  /*
  depends_on = [
    azurerm_key_vault_access_policy.client,
    azurerm_key_vault_access_policy.server,
  ]
*/
}
