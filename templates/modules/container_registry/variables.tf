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

variable "sku" {
  type = string
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU has to be set to either Basic, Standard or Premium. Basic is default."
  }
  default     = "Basic"
  description = "The SKU name of the container registry."
}

variable "read_access" {
  type        = list(string)
  description = "List of ids of users and groups that should have access to pull from ACR."
  default     = []
}

variable "write_access" {
  type        = list(string)
  description = "List of ids of users and groups that should have access to push to ACR."
  default     = []
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to resources."
}

variable "georeplication_locations" {
  type = list(object({
    location                  = string
    zone_redundancy_enabled   = bool
    regional_endpoint_enabled = bool
    tags                      = map(string)
  }))
  description = "A list of Azure locations where the Ccontainer Registry should be geo-replicated."
  default     = []
}

variable "quarantine_enabled" {
  type        = bool
  description = "Boolean value that indicates whether quarantine policy is enabled."
  default     = false
}
