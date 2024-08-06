#random integer for naming

resource random_integer random-alias {
    min = 1
    max = 9999
}

resource azurerm_resource_group rg-alias {
  name     = var.rg-name[random_integer.random_alias.result]
  location = var.location
}

resource azurerm_kubernetes_cluster aks-alias {
  name                = var.aks-name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-alias.name
  dns_prefix          = var.dns-prefix

  default_node_pool {
    name       = var.node-pool-name
    node_count = 1
    vm_size    = "Standard_D2as_V4"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environtment = var.tags_name[1]
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks-alias.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw

  sensitive = true
}