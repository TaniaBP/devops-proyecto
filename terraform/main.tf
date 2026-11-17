resource "azurerm_resource_group" "main" {
  name     = "rg-devops-academia-2"
  location = var.location
  tags = {
    environment = var.environment
    project     = "devops-academia-v2"
  }
}

resource "azurerm_storage_account" "main" {
  name                     = "ststagingdevops2026n"
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
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_B2s_v2"
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }

  node_provisioning_profile {
    mode = "Manual"
  }

  tags = {
    environment = var.environment
    project     = "devops-academia"
  }
}