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

variable "secrets" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "Key value pairs of keyvault secrets to add."
}