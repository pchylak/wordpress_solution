terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.20.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.25"
    }
  }

  required_version = ">= 1.9.4"
}