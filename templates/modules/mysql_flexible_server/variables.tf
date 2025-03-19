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

variable "server_sku" {
  type        = string
  description = "The SKU of the MySQL server."
  default     = "B_Standard_B1s"
}

variable "create_private_endpoint" {
  type        = bool
  description = "Create a private endpoint for the MySQL server."
  default     = false
}

variable "virtual_network_id" {
  type        = string
  description = "The ID of the virtual network where the MySQL server will be deployed."
}