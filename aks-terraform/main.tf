provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "k8s" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "dev"
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "demo-aks-cluster"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = "demo-aks-cluster-dns"
  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  tags = {
    environment = "dev"
  }
}