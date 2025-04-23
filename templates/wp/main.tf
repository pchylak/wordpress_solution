module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "7.3.1"

  azure_region = var.region_name
}

resource "azurecaf_name" "this" {
  resource_types = [
    "azurerm_resource_group",
    "azurerm_mysql_database",
    "azurerm_app_service"
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
  source = "../modules/managed_identity"

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

resource "azurerm_mysql_flexible_database" "wordpressdb" {
  name                = format("%s-%02s", azurecaf_name.this.results["azurerm_mysql_database"], var.environment.number)
  resource_group_name = azurerm_resource_group.this.name
  server_name         = data.terraform_remote_state.general.outputs.mysql_flexible_server.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

resource "azurerm_app_service" "wordpress" {
  name                = format("%s-%02s", azurecaf_name.this.results["azurerm_app_service"], var.environment.number)
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  app_service_plan_id = data.terraform_remote_state.general.outputs.app_service_plan.id

  app_settings = {
    WORDPRESS_DB_HOST     = data.terraform_remote_state.general.outputs.mysql_flexible_server.host
    WORDPRESS_DB_NAME     = azurerm_mysql_flexible_database.wordpressdb.name
    WORDPRESS_DB_USER     = data.terraform_remote_state.general.outputs.mysql_flexible_server.username
    WORDPRESS_DB_PASSWORD = data.terraform_remote_state.general.outputs.mysql_flexible_server.password
    WEBSITES_PORT         = "80"
  }

  https_only = true
}
