output "virtual_network" {
  value = {
    name = azurerm_virtual_network.this.name
    id   = azurerm_virtual_network.this.id
  }
}