module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "7.3.1"

  azure_region = var.resource_group.location
}

resource "azurecaf_name" "this" {
  resource_types = [
    "azurerm_virtual_network",
    "azurerm_subnet"
  ]
  name        = var.caf_name == "" ? module.azure_region.location_short : var.caf_name
  prefixes    = [var.project_name, substr(var.environment.name, 0, 3)]
  suffixes    = [var.caf_resources_suffix]
  clean_input = true
}

resource "azurerm_virtual_network" "this" {
  name                = format("%s-%02s", azurecaf_name.this.results["azurerm_virtual_network"], var.environment.number)
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  address_space       = var.vnet_cidr
  dns_servers         = var.dns_servers
  tags                = var.tags
  dynamic "subnet" {
    for_each = var.subnets
    content {
      name              = subnet.value.name
      address_prefixes  = [subnet.value.cidr]
      service_endpoints = subnet.value.service_endpoints
    }
  }
}
