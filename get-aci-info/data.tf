terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}


data "azurerm_container_registry" "acr" {
  name                = "ACRNAME"
  resource_group_name = "RGNAME"
}

output "login_server" {
  value = data.azurerm_container_registry.acr.login_server
}

output "admin_username" {
  value = data.azurerm_container_registry.acr.admin_username
}

output "admin_password" {
  value = data.azurerm_container_registry.acr.admin_password


}
