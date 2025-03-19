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

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Resource group where the managed identity will be created."
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

variable "dns_servers" {
  type        = list(string)
  description = "List of DNS servers to use for the virtual network."
  default     = []
}

variable "vnet_cidr" {
  type        = list(string)
  description = "Defines VNet address spaces in CIDR notation."
  validation {
    condition     = can([for cidr in var.vnet_cidr : cidrnetmask(cidr)])
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "subnets" {
  type = list(object({
    cidr              = string
    service_endpoints = list(string)
  }))
  description = "List of subnets to create in the virtual network."
}