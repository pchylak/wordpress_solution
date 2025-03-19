deployment_subscription_id = "16571c19-57ee-46ce-90dd-1bc011c2d246"
tags = {
  "environment" = "prd"
  "project"     = "it"
}
environment = {
  name   = "p"
  number = 1
}
region_name          = "swedencentral"
project_name         = "it"
caf_resources_suffix = "general"
vnet_cidr            = ["10.0.0.0/22"]
subnets = [
  {
    cidr              = "10.0.0.0/24"
    service_endpoints = []
  },
  {
    cidr              = "10.0.1.0/24"
    service_endpoints = []
  }
]