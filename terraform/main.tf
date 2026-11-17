terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "environment" {
  type    = string
  default = "staging"
}

variable "node_count" {
  type    = number
  default = 2
}

resource "azurerm_resource_group" "main" {
  name     = "rg-devops-academia"
  location = "eastus"
  tags = {
    environment = "staging"
    project     = "devops-academia"
  }
}

resource "azurerm_storage_account" "main" {
  name                     = "ststagingdevops2026x"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-staging-devops"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.environment}-devops"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aks${var.environment}devops"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.environment
    project     = "devops-academia"
  }
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}