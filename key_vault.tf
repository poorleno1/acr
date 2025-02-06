data "azurerm_key_vault" "kv" {
  name                = local.shared_key_vault_name
  resource_group_name = local.shared_key_vault_resource_group_name
}

data "azurerm_key_vault_secret" "github-access-key" {
  name         = "github-access-key"
  key_vault_id = data.azurerm_key_vault.shared.id
}