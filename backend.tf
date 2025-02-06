terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">3.88.0"
    }

    azapi = {
      source = "Azure/azapi"
    }
  }

  backend "azurerm" {
    environment          = "public"
    storage_account_name = "tfstatejarek2"
    container_name       = "tfstate"
    key                  = "container-registry.tfstate"
    resource_group_name  = "terraform"
  }
}