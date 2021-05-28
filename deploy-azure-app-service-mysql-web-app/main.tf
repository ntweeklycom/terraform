terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.61.0"
    }
  }
}

provider "random" {
  # Configuration options
}



provider "azurerm" {

  features{}
}

resource "azurerm_resource_group" "rg" {
  name     = "deploycontainers"
  location = "westus"
}

resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "deploycontainers"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "azurerm_mysql_server" "mysql" {
  name                = "ntwmysql"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login          = "mysqladmin"
  administrator_login_password = random_password.password.result

  sku_name   = "B_Gen5_1"
  storage_mb = 10240
  version    = "8.0"
  ssl_enforcement_enabled = true

  
}

resource "azurerm_app_service" "webapp" {
  name                = "deploycontainerswordpress"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id 

  } 

output "password" {
  description = "The MySQL DB password is:" 
  value = random_password.password.result
  sensitive = true
}