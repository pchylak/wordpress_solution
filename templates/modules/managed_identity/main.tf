module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "7.3.1"

  azure_region = var.resource_group.location
}

resource "azurecaf_name" "this" {
  resource_types = [
    "azurerm_managed_identity"
  ]
  name        = var.caf_name == "" ? module.azure_region.location_short : var.caf_name
  prefixes    = [var.project_name, substr(var.environment.name, 0, 3)]
  suffixes    = [module.azure_region.location_short, var.caf_resources_suffix]
  clean_input = true
}

resource "azurerm_user_assigned_identity" "this" {
  name                = format("%s-%02s", azurecaf_name.this.results["azurerm_managed_identity"], var.environment.number)
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tags                = var.tags
}

resource "azurerm_role_assignment" "this" {
  for_each             = { for permission in var.permissions : permission.scope => permission }
  principal_id         = azurerm_user_assigned_identity.this.principal_id
  scope                = each.value.scope
  role_definition_name = each.value.role_name
}

resource "azurerm_federated_identity_credential" "this" {
  count               = var.oidc.enabled ? 1 : 0
  name                = "Kubernetes ServiceAccount ${var.oidc.kubernetes_namespace}-${var.oidc.kubernetes_serviceaccount_name}"
  resource_group_name = var.resource_group.name
  audience            = var.oidc.audience
  issuer              = var.oidc.issuer_url
  parent_id           = azurerm_user_assigned_identity.this.id
  subject             = "system:serviceaccount:${var.oidc.kubernetes_namespace}:${var.oidc.kubernetes_serviceaccount_name}"
}
