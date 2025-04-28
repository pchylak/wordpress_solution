output "mysql_flexible_server" {
  value = {
    name     = module.mysql_flexible_server.mysql_flexible_server.name
    id       = module.mysql_flexible_server.mysql_flexible_server.id
    host     = format("%s.mysql.database.azure.com", module.mysql_flexible_server.mysql_flexible_server.name)
    username = module.mysql_flexible_server.mysql_flexible_server.username
    password = module.mysql_flexible_server.mysql_flexible_server.password
  }
  sensitive = true
}

output "service_plan" {
  value = {
    id   = module.app_service_plan.service_plan.id
    name = module.app_service_plan.service_plan.name
  }
}

output "container_registry" {
  value = {
    id   = module.container_registry.id
    name = module.container_registry.name
  }
}

output "resource_group" {
  value = {
    name     = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location
  }

}

output "keyvault" {
  value = {
    id   = module.keyvault.keyvault.id
    name = module.keyvault.keyvault.name
  }
  sensitive = true
}