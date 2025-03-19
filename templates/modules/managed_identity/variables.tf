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

variable "permissions" {
  type = list(object({
    scope                            = string
    role_name                        = string
    skip_service_principal_aad_check = optional(bool, false)
  }))
  description = "Defines a list of role names and scopes to assign to the managed identity."
  default     = []
}

variable "oidc" {
  type = object({
    enabled                        = bool
    audience                       = optional(list(string), ["api://AzureADTokenExchange"])
    issuer_url                     = string
    kubernetes_namespace           = string
    kubernetes_serviceaccount_name = string
  })
  description = "Configure OIDC federation settings to establish a trusted token mechanism between the Kubernetes cluster and external systems."
  default = {
    enabled                        = false
    issuer_url                     = ""
    kubernetes_namespace           = ""
    kubernetes_serviceaccount_name = ""
  }
}