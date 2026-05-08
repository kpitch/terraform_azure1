variable "location" {
  description = "Azure region"
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Resource Group Name"
  default     = "elekta-devops-test"
}

variable "admin_username" {
  description = "VM admin username"
  default     = "Elekta"
}

variable "admin_password" {
  description = "VM admin password"
  sensitive   = true
}