resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source = "./modules/network"

  resource_group_name = var.resource_group_name
  location            = var.location

  depends_on = [
    azurerm_resource_group.rg
  ]
}

module "vm1" {
  source = "./modules/windows-vm"

  vm_name             = "vm-test-1"
  location            = var.location
  resource_group_name = var.resource_group_name

  subnet_id = module.network.subnet_id

  admin_username = var.admin_username
  admin_password = var.admin_password

  depends_on = [
    module.network
  ]
}

module "vm2" {
  source = "./modules/windows-vm"

  vm_name             = "vm-test-2"
  location            = var.location
  resource_group_name = var.resource_group_name

  subnet_id = module.network.subnet_id

  admin_username = var.admin_username
  admin_password = var.admin_password

  depends_on = [
    module.network
  ]
}