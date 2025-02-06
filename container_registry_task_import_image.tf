resource "null_resource" "import_image_ubuntu_22" {
  provisioner "local-exec" {
    interpreter = ["powershell", "-Command"]
    command = <<EOT
      az acr import `
        --name ${azurerm_container_registry.acr.name} `
        --source docker.io/library/ubuntu:22.04 `
        --image ${local.acr_baseimages_repo_name}/ubuntu:22.04 `
        --force
    EOT
  }

  depends_on = [azurerm_container_registry.acr]
  # triggers = {
  #   always_run = "${timestamp()}"
  # }
}


resource "null_resource" "import_image_ubuntu_latest" {
  provisioner "local-exec" {
    interpreter = ["powershell", "-Command"]
    command = <<EOT
      az acr import `
        --name ${azurerm_container_registry.acr.name} `
        --source docker.io/library/ubuntu:latest `
        --image ${local.acr_baseimages_repo_name}/ubuntu:latest `
        --force
    EOT
  }

  depends_on = [azurerm_container_registry.acr]
  # triggers = {
  #   always_run = "${timestamp()}"
  # }
}

resource "null_resource" "import_image_python" {
  provisioner "local-exec" {
    interpreter = ["powershell", "-Command"]
    command = <<EOT
      az acr import `
        --name ${azurerm_container_registry.acr.name} `
        --source docker.io/library/python:3.13-slim `
        --image ${local.acr_baseimages_repo_name}/python:3.13-slim
        --force
    EOT
  }

  depends_on = [azurerm_container_registry.acr]
}



resource "null_resource" "import_image_portainer_agent" {
  provisioner "local-exec" {
    interpreter = ["powershell", "-Command"]
    command = <<EOT
      az acr import `
        --name ${azurerm_container_registry.acr.name} `
        --source docker.io/portainer/agent:latest `
        --image ${local.acr_baseimages_repo_name}/portainer/agent:latest `
        --force

    EOT
  }

  depends_on = [azurerm_container_registry.acr]
}



resource "null_resource" "import_image_accli" {
  provisioner "local-exec" {
    interpreter = ["powershell", "-Command"]
    command = <<EOT
      az acr import `
        --name ${azurerm_container_registry.acr.name} `
        --source mcr.microsoft.com/azure-cli:latest `
        --image mcr.microsoft.com/azure-cli:latest `
        --force
    EOT
  }

  depends_on = [azurerm_container_registry.acr]
  # triggers = {
  #   always_run = "${timestamp()}"
  # }
}
