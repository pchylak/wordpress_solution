module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "7.3.1"

  azure_region = var.resource_group.location
}

resource "azurecaf_name" "this" {
  resource_type = "azurerm_mysql_flexible_server"
  name          = var.caf_name == "" ? module.azure_region.location_short : var.caf_name
  prefixes      = [var.project_name, substr(var.environment.name, 0, 3)]
  suffixes      = [var.caf_resources_suffix]
  clean_input   = true
}

resource "random_string" "this" {
  length  = 12
  special = false
}

resource "random_password" "this" {
  length  = 36
  special = true
}

resource "azurerm_private_dns_zone" "this" {
  count = var.create_private_endpoint == true ? 1 : 0

  name                = format("%s.%s", format("%s-%02s", azurecaf_name.this.result, var.environment.number), "private.mysql.database.azure.com")
  resource_group_name = var.resource_group.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  count                 = var.create_private_endpoint == true ? 1 : 0
  name                  = "mysql_private_dns_link"
  private_dns_zone_name = azurerm_private_dns_zone.this[0].name
  virtual_network_id    = var.virtual_network_id
  resource_group_name   = var.resource_group.name

  depends_on = [azurerm_private_dns_zone.this]
}

resource "azurerm_mysql_flexible_server" "this" {
  name                         = format("%s-%02s", azurecaf_name.this.result, var.environment.number)
  location                     = var.resource_group.location
  resource_group_name          = var.resource_group.name
  administrator_login          = random_string.this.result
  administrator_password       = random_password.this.result
  sku_name                     = var.server_sku
  backup_retention_days        = 30
  geo_redundant_backup_enabled = false
  version                      = var.mysql_version
  #delegated_subnet_id          = var.create_private_endpoint == true ? var.delegated_subnet_id : null
  #private_dns_zone_id          = var.create_private_endpoint == true ? azurerm_private_dns_zone.this[0].id : null

  lifecycle {
    ignore_changes = [
      zone
    ]
  }

  depends_on = [azurerm_private_dns_zone.this]
  tags       = var.tags
}

resource "azurerm_mysql_flexible_server_firewall_rule" "example" {
  name                = "AzureFirewallRule"
  resource_group_name = var.resource_group.name
  server_name         = azurerm_mysql_flexible_server.this.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}