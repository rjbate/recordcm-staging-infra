terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.103.1"
      #version = "=3.92.0"
      #3.92.0 for SB bug?
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.13.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.30.0"
    }
    modtm = {
      source  = "Azure/modtm"
      version = ">= 0.2.0, < 1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    git = {
      source  = "metio/git"
      version = ">= 2024.6.7"
    }
  }
  required_version = ">= 1.8.0"
}

provider "azapi" {}

provider "azurerm" {
  skip_provider_registration = true
  features {

    app_configuration {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = true
    }

    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azuread" {}

provider "git" {}

provider "modtm" {
  enabled = false
}

data "azurerm_client_config" "current" {}
