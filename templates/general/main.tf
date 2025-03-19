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

module "managed_identity" {
  source = "./modules/managed_identity"

  tags        = var.tags
  environment = var.environment
  resource_group = {
    name     = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location
  }

  project_name         = var.project_name
  caf_name             = var.caf_name
  caf_resources_suffix = var.caf_resources_suffix

  permissions = var.permissions
}

module "app_service_plan" {
  source = "./modules/app_service_plan"

  app_service_plan_size = "P1v2"
  app_service_plan_tier = "PremiumV2"
  caf_name              = var.caf_name
  caf_resources_suffix  = var.caf_resources_suffix
  environment           = var.environment
  project_name          = var.project_name
  resource_group = {
    location = azurerm_resource_group.this.location
    name     = azurerm_resource_group.this.name
  }
  tags = var.tags
}