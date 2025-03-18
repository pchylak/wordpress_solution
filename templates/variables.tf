variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where state will be created."
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account where the Terraform state file will be stored."
}

variable "container_name" {
  type        = string
  description = "Name of the container where the Terraform state file will be stored."
}

variable "subscription_id" {
  type        = string
  description = "Subscription id where state will be created."

}

variable "deployment_subscription_id" {
  type        = string
  description = "Subscription id where resources will be created."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to be added to created resources"
}

variable "environment" {
  type = object({
    name   = string
    number = number
  })
  description = "Environment name and number."
}

variable "region_name" {
  type        = string
  description = "Azure Region standard name, CLI name or slug format (used by Claranet tfwrapper) where resources will be created."
  default     = "eu-west"
}

variable "project_name" {
  type        = string
  description = "Project name."
}

variable "caf_name" {
  type        = string
  description = "CAF custom basename of the resource to create."
  default     = ""
}

variable "caf_resources_suffix" {
  type        = string
  description = "Defines CAF resources suffix."
}

variable "vnet_cidr" {
  type        = list(string)
  description = "Defines VNet address spaces in CIDR notation."
  validation {
    condition     = can([for cidr in var.vnet_cidr : cidrnetmask(cidr)])
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "dns_servers" {
  type        = list(string)
  description = "DNS servers for the VNET"
}

variable "services_subnet_cidr" {
  type        = list(string)
  description = "Defines firewall subnet address spaces in CIDR notation."
  validation {
    condition     = can([for cidr in var.firewall_subnet_cidr : cidrnetmask(cidr)])
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}