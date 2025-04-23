output "id" {
  description = "Container registry ID"
  value       = azurerm_container_registry.this.id
}

output "name" {
  description = "Container registry name"
  value       = azurerm_container_registry.this.name
}
