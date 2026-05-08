terraform {
  backend "azurerm" {
    # Kept intentionally empty so backend values come from
    # CLI flags / Azure DevOps pipeline variables.
  }
}