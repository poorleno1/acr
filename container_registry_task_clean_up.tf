resource "azurerm_container_registry_task" "daily_purge_prod_images" {
  name                  = "daily_purge_prod_images"
  container_registry_id = azurerm_container_registry.acr.id

  agent_setting {
    cpu = 2
  }

  platform {
    architecture = "amd64"
    os           = "Linux"
    variant      = null
  }

  encoded_step {
    task_content = base64encode(yamlencode({
      version : "v1.1.0",
      steps : [
        {
          cmd : "mcr.microsoft.com/acr/acr-cli:0.5 purge --untagged --ago 7d --filter '*:[^0-9.]+$' --keep 3"
          disableWorkingDirectoryOverride : true,
          timeout : 3600
        }
      ]
    }))
    values = {}
  }

  timer_trigger {
    name     = "daily at 1AM"
    schedule = "0 1 * * *"
  }

  base_image_trigger {
    type                        = "Runtime"
    name                        = "defaultBaseimageTriggerName"
    update_trigger_payload_type = "Default"
  }
}