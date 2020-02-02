provider azurerm {
  tenant_id = var.azure-tenant-id
  subscription_id = var.azure-subscription-id
  environment = var.azure-environment-name
  version = ">= 1.42.0"
}

terraform {
  backend "azurerm" {
    resource_group_name = "terraform-ufst"
    storage_account_name = "kaleidoscopesoftware"
    container_name = "terraform-state"
    key = "dev.tfstate"
  }
  required_version = ">= 0.12"
}
