resource "random_integer" "rand_minute" {
  for_each = toset(local.base_container_image_names)
  min      = 0
  max      = 59
}

resource "azurerm_container_registry_task" "daily_base_image_update" {
  for_each = toset(local.base_container_image_names)
  name                  = "daily_base_image_update_${replace(replace(each.key,":","-"),".","-")}"
  container_registry_id = azurerm_container_registry.acr.id

  agent_setting {
    cpu = 2
  }
  identity {
    type = "SystemAssigned"
  }

  platform {
    architecture = "amd64"
    os           = "Linux"
    variant      = null
  }

  #cmd : "mcr.microsoft.com/azure-cli:latest az login --identity && az acr import --name ${azurerm_container_registry.acr.name} --source docker.io/library/${each.key} --image  ${local.acr_baseimages_repo_name}/${each.key} --force"
  #cmd : "mcr.microsoft.com/azure-cli:latest az acr import --name ${azurerm_container_registry.acr.name} --source docker.io/library/${each.key} --image  ${local.acr_baseimages_repo_name}/${each.key} --force"
  #cmd : "mcr.microsoft.com/azure-cli:latest /bin/bash -c 'az login --identity && az account show && az account set --subscription 7b66abb8-9aed-44ce-bc82-c5d07d6b9a93 && az acr list -o table && az acr import --name ${azurerm_container_registry.acr.name} --source docker.io/library/${each.key} --image  ${local.acr_baseimages_repo_name}/${each.key} --force'",
  #mcr.microsoft.com/azure-cli:latest /bin/bash -c 'az login --identity && az account show && az account set --subscription 7b66abb8-9aed-44ce-bc82-c5d07d6b9a93 && az acr list -o table && az acr import --name ${azurerm_container_registry.acr.name} --source docker.io/library/${each.key} --image  ${local.acr_baseimages_repo_name}/${each.key} --force'
  #mcr.microsoft.com/azure-cli:latest /bin/bash -c 'az login --identity && az account show && az account set --subscription 7b66abb8-9aed-44ce-bc82-c5d07d6b9a93 && az acr list -o table && az acr import --name ${azurerm_container_registry.acr.name} --source "docker.io/library/${each.key}" --image  "${local.acr_baseimages_repo_name}/${each.key}"'

  encoded_step {
    task_content = base64encode(yamlencode({
      version : "v1.1.0",
      steps : [
        {
          cmd : <<EOT
          mcr.microsoft.com/azure-cli:latest /bin/bash -c 'az login --identity && az acr import --name ${azurerm_container_registry.acr.name} --source docker.io/library/${each.key} --image ${local.acr_baseimages_repo_name}/${each.key} --force && echo "End"'
          EOT
          disableWorkingDirectoryOverride : true,
          timeout : 3600
        }
      ]
    }))
    values = {}
  }

  timer_trigger {
    name     = "daily at 2AM"
    schedule = "${random_integer.rand_minute[each.key].result} 2 * * *"
    #schedule = "${random_integer.rand_minute[each.key].result} * * * *"
  }

  base_image_trigger {
    type                        = "Runtime"
    name                        = "defaultBaseimageTriggerName"
    update_trigger_payload_type = "Default"
  }
}



resource "azurerm_role_assignment" "daily_base_image_update_pull" {
  for_each              = toset(local.base_container_image_names)
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "acrpull"
  principal_id         = azurerm_container_registry_task.daily_base_image_update[each.key].identity.0.principal_id
  depends_on = [
    azurerm_container_registry_task.daily_base_image_update
  ]
}


resource "azurerm_role_assignment" "daily_base_image_update_push" {
  for_each              = toset(local.base_container_image_names)
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "acrpush"
  principal_id         = azurerm_container_registry_task.daily_base_image_update[each.key].identity.0.principal_id
  depends_on = [
    azurerm_container_registry_task.daily_base_image_update
  ]
}

resource "azurerm_role_assignment" "daily_base_image_update_reader" {
  for_each              = toset(local.base_container_image_names)
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_container_registry_task.daily_base_image_update[each.key].identity.0.principal_id
  depends_on = [
    azurerm_container_registry_task.daily_base_image_update
  ]
}