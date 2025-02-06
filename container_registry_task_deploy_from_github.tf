# ACR Task to Build and Push Image from GitHub Repository
resource "azurerm_container_registry_task" "github_task" {
  name                = "github-build-task"
  container_registry_id = azurerm_container_registry.acr.id
  
  # Define the platform for the task
  platform {
    os           = "Linux"
    architecture = "amd64"
  }

  identity {
    type = "SystemAssigned"
  }

  # registry_credential {
  #   source {
  #     login_mode = "Default"
  #   }
  # }

  # Define the build step

  docker_step {
    dockerfile_path      = "Dockerfile-mb.azure-pipelines"
    context_path         = "https://github.com/poorleno1/container-apps-ci-cd-runner-tutorial.git"
    context_access_token = data.azurerm_key_vault_secret.github-access-key.value
    image_names          = ["azure-devops-agent:{{.Run.ID}}"]
    arguments = {
      "REGISTRY_NAME" = "${azurerm_container_registry.acr.login_server}/${local.acr_baseimages_repo_name}"
    }
    
  }

  
  
# Define a trigger for GitHub commits
  source_trigger {
    name       = "github-source-trigger"
    enabled = true
    events = [ "commit" ]
    repository_url = "https://github.com/poorleno1/container-apps-ci-cd-runner-tutorial.git"
    source_type = "Github"
    branch = "main"
    authentication {
        token = data.azurerm_key_vault_secret.github-access-key.value
        token_type = "PAT"
    }
  }

  base_image_trigger {
    type                        = "Runtime"
    name                        = "defaultBaseimageTriggerName"
    update_trigger_payload_type = "Default"
  }
}

resource "azurerm_container_registry_task_schedule_run_now" "github_task_run_now" {
  container_registry_task_id = azurerm_container_registry_task.github_task.id
}



resource "azurerm_role_assignment" "acr_task_identity" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "acrpull"
  principal_id         = azurerm_container_registry_task.github_task.identity[0].principal_id
  depends_on = [
    azurerm_container_registry_task.github_task
  ]
}


resource "azurerm_role_assignment" "acr_task_identity_push" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "acrpush"
  principal_id         = azurerm_container_registry_task.github_task.identity[0].principal_id
  depends_on = [
    azurerm_container_registry_task.github_task
  ]
}