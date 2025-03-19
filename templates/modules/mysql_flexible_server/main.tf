module "azure_region" {
  #checkov:skip=CKV_TF_1
  source  = "claranet/regions/azurerm"
  version = "6.1.0"

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

resource "azurerm_mysql_flexible_server" "this" {
  name                         = format("%s-%02s", azurecaf_name.this.result, var.environment.number)
  location                     = var.resource_group.location
  resource_group_name          = var.resource_group.name
  administrator_login          = random_string.this.result
  administrator_password       = random_password.this.result
  sku_name                     = var.server_sku
  backup_retention_days        = 30
  geo_redundant_backup_enabled = false

  lifecycle {
    ignore_changes = [
      zone
    ]
  }
}

resource "azurerm_private_dns_zone" "this" {
  count = var.create_private_endpoint == true ? 1 : 0

  name                = format("%s.%s", azurerm_mysql_flexible_server.this.name, "private.mysql.database.azure.com")
  resource_group_name = var.resource_group.name

  depends_on = [azurerm_mysql_flexible_server.this]
  tags       = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "mysql_private_dns_link"
  private_dns_zone_name = azurerm_private_dns_zone.this.name[0]
  virtual_network_id    = var.virtual_network_id
  resource_group_name   = var.resource_group.name

  depends_on = [azurerm_private_dns_zone.this]
}