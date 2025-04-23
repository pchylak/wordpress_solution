output "mysql_flexible_server" {
  value = {
    name     = module.mysql_flexible_server.mysql_flexible_server.name
    id       = module.mysql_flexible_server.mysql_flexible_server.id
    host     = format("%s.mysql.database.azure.com", module.mysql_flexible_server.mysql_flexible_server.name)
    username = module.mysql_flexible_server.mysql_flexible_server.administrator_login
    password = module.mysql_flexible_server.mysql_flexible_server.administrator_password
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