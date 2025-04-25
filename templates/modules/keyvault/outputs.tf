output "keyvault" {
  value = {
    name      = azurerm_key_vault.this.name
    id        = azurerm_key_vault.this.id
    vault_uri = azurerm_key_vault.this.vault_uri
  }
  sensitive = false
}