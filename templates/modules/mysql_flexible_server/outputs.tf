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