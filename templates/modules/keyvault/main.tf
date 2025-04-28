module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "7.3.1"

  azure_region = var.resource_group.location
}

resource "azurecaf_name" "this" {
  resource_types = [
    "azurerm_key_vault"
  ]
  name        = var.caf_name == "" ? module.azure_region.location_short : var.caf_name
  prefixes    = [var.project_name, substr(var.environment.name, 0, 3)]
  suffixes    = [var.caf_resources_suffix]
  clean_input = true
}

resource "azurerm_key_vault" "this" {
  name                       = azurecaf_name.this.results["azurerm_key_vault"]
  location                   = var.resource_group.location
  resource_group_name        = var.resource_group.name
  sku_name                   = "standard"
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  enable_rbac_authorization  = true

  tags = var.tags

}

resource "azurerm_key_vault_secret" "secret" {
  count        = length(var.secrets)
  name         = var.secrets[count.index].name
  value        = var.secrets[count.index].value
  key_vault_id = azurerm_key_vault.this.id
  content_type = "text/plain"
  depends_on = [
    azurerm_key_vault.this
  ]
}