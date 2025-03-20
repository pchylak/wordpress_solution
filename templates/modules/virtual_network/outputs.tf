output "virtual_network" {
  value = {
    name = azurerm_virtual_network.this.name
    id   = azurerm_virtual_network.this.id
  }
}

output "subnet" {
  value = { for subnet in azurerm_virtual_network.this.subnet : subnet.name => subnet.id }
}