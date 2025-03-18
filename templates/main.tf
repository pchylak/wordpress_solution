module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "7.3.1"

  azure_region = var.region_name
}

resource "azurecaf_name" "this" {
  resource_types = [
    "azurerm_resource_group"
  ]
  name        = var.caf_name == "" ? module.azure_region.location_short : var.caf_name
  prefixes    = [var.project_name, substr(var.environment.name, 0, 3)]
  suffixes    = [module.azure_region.location_short, var.caf_resources_suffix]
  clean_input = true
}

resource "azurerm_resource_group" "this" {
  name     = format("%s-%02s", azurecaf_name.this.results["azurerm_resource_group"], var.environment.number)
  location = var.region_name
  tags     = var.tags
}