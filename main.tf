terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.81.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "project" {
  name     = "rg-terraform-project3"
  location = "centralindia"
}

module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.project.name
  location            = azurerm_resource_group.project.location
  name_prefix         = "project3"
  vnet_cidr           = "10.30.0.0/16"
  subnet_cidr         = "10.30.1.0/24"
}