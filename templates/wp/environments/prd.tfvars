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
caf_resources_suffix = "wp"
permissions = [
  {
    scope                            = data.terraform_remote_state.general.outputs.container_registry.id
    role_name                        = "AcrPull"
    skip_service_principal_aad_check = true
  }
]