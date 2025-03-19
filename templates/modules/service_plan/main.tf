module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "7.3.1"

  azure_region = var.resource_group.location
}

resource "azurecaf_name" "this" {
  resource_types = [
    "azurerm_app_service_plan"
  ]
  name        = var.caf_name == "" ? module.azure_region.location_short : var.caf_name
  prefixes    = [var.project_name, substr(var.environment.name, 0, 3)]
  suffixes    = [module.azure_region.location_short, var.caf_resources_suffix]
  clean_input = true
}

resource "azurerm_service_plan" "this" {
  name                = format("%s-%02s", azurecaf_name.this.results["azurerm_app_service_plan"], var.environment.number)
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  os_type             = var.service_plan_os
  sku_name            = var.service_plan_sku

  tags = var.tags
}