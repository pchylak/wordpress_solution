output "mysql_flexible_server" {
  value = {
    name     = azurerm_mysql_flexible_server.this.name
    id       = azurerm_mysql_flexible_server.this.id
    host     = format("%s.mysql.database.azure.com", azurerm_mysql_flexible_server.this.name)
    username = azurerm_mysql_flexible_server.this.administrator_login
    password = random_password.this.result
  }
  sensitive = true
}

output "service_plan" {
  value = {
    id   = data.terraform_remote_state.general.service_plan.app_service_plan.id
    name = data.terraform_remote_state.general.service_plan.app_service_plan.name
  }
}

output "container_registry" {
  value = {
    id   = data.terraform_remote_state.general.container_registry.container_registry.id
    name = data.terraform_remote_state.general.container_registry.container_registry.name
  }
}