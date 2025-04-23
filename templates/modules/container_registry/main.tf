module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "7.3.1"

  azure_region = var.resource_group.location
}

resource "azurecaf_name" "this" {
  resource_types = [
    "azurerm_container_registry"
  ]
  name        = var.caf_name == "" ? module.azure_region.location_short : var.caf_name
  prefixes    = [var.project_name, substr(var.environment.name, 0, 3)]
  suffixes    = [module.azure_region.location_short, var.caf_resources_suffix]
  clean_input = true
}

resource "azurerm_container_registry" "this" {
  name                      = format("%s%02s", azurecaf_name.this.results["azurerm_container_registry"], var.environment.number)
  resource_group_name       = var.resource_group.name
  location                  = var.resource_group.location
  sku                       = var.sku
  admin_enabled             = false
  anonymous_pull_enabled    = false
  quarantine_policy_enabled = var.quarantine_enabled

  dynamic "georeplications" {
    for_each = var.georeplication_locations != null && var.sku == "Premium" ? var.georeplication_locations : []
    content {
      location                  = georeplications.value.location
      zone_redundancy_enabled   = georeplications.value.zone_redundancy_enabled
      regional_endpoint_enabled = georeplications.value.regional_endpoint_enabled
      tags                      = georeplications.value.tags
    }
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "read" {
  for_each                         = toset(var.read_access)
  principal_id                     = each.key
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.this.id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "write" {
  for_each                         = toset(var.write_access)
  principal_id                     = each.key
  role_definition_name             = "AcrPush"
  scope                            = azurerm_container_registry.this.id
  skip_service_principal_aad_check = true
}
