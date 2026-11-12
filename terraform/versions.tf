terraform {
    backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstatedevops2379"
    container_name       = "tfstate"
    key                  = "devops-academia.tfstate"
  }
  required_version = ">= 1.6.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }


}

provider "azurerm" {
  features {}
}