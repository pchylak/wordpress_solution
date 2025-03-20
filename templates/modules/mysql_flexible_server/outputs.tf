output "mysql_flexible_server" {
  value = {
    name = azurerm_mysql_flexible_server.this.name
    id   = azurerm_mysql_flexible_server.this.id
  }
}