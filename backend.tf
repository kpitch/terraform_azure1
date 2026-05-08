terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatekp2026dev123"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}