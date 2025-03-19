output "service_plan" {
  value = {
    name = azurerm_service_plan.this.name
    id   = azurerm_service_plan.this.id
  }
}