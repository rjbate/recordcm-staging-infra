data "azurerm_resource_group" "example" {
  name = var.resource_group_name
}

data "terraform_remote_state" "shared_state" {
  backend = "azurerm"
  config = {
    key                  = "terraform.tfstate"
    resource_group_name  = "recordcm-record-state"
    storage_account_name = var.storage_account_state
    container_name       = "sharedservices"
  }
}

data "terraform_remote_state" "base_state" {
  backend = "azurerm"
  config = {
    key                  = "terraform.tfstate"
    resource_group_name  = "recordcm-record-state"
    storage_account_name = var.storage_account_state
    container_name       = var.record_env_base
  }
}
