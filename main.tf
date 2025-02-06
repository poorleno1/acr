variable "SUBSCRIPTION_ID" {}

provider "azurerm" {
  subscription_id = var.SUBSCRIPTION_ID
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}


data "azurerm_subscription" "current" {}
output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}
data "azurerm_client_config" "current" {}


resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  tags     = local.tags
  location = var.location
}
