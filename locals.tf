locals {
  suffix = "container-registy"
  resource_group_name  = "rg-${local.suffix}"
  tags = merge(var.tags, tomap({ "Environment" = var.Environment }))
  log_analytics_name = "la-${local.suffix}"
  App_Insight_name = "appins-${local.suffix}"
  container_app_environment_name = "ca-${local.suffix}"
  container_app_msi = "msi-${local.suffix}"
  shared_key_vault_resource_group_name = "archiwum"
  shared_key_vault_name = "jarekvault"


  acr_name = "acr${replace(local.suffix,"-","")}"
  acr_rg_name = "AI_Resources"
  acr_baseimages_repo_name = "baseimages"

  network_address_space = "10.30.0.0/19"
  container_network_space  = cidrsubnet(local.network_address_space, 2, 0)
  deployment_network_space = cidrsubnet(local.network_address_space, 5, 8)
  vnet_name = "vnet_name"
  common_rg_name = "common_rg_name"
  snet_ca_name = "ContainerApps3"
  snet_deployment_name = "web-subnet"

  container_app_environment_name_ext = "container-apps-env-external-${local.suffix}"

  storage_account_app_name = "stormdbrf${lower(local.tags["Environment"])}"
  ca_name = "ca"
  storage_share_name = "volume-${local.ca_name}"

  storage_share_folder_structure = [
    "data"
  ]

  base_container_image_names = ["ubuntu:latest","ubuntu:22.04","python:3.12-slim"]

  container_app_name = "${lower(local.ca_name)}-${lower(local.suffix)}"

}