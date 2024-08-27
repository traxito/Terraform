#We will make this TF plan to be independent from other TF's or resources, to be able to work alone

#variables for unique names

resource random_string random-name {
  length    = 3
  special   = false
  lower     = true
  min_lower = 3
}

resource random_integer random-alias {
  min = 1
  max = 5000
}

locals {
  rgname = "${terraform.workspace}_${var.rg-name}_${random_integer.random-alias.result}"
  stname = "${terraform.workspace}${var.st-name}${random_integer.random-alias.result}"
  vmname = "${terraform.workspace}_${var.vm-name}_${random_integer.random-alias.result}"
  vnetname = "${terraform.workspace}_${var.vnet-name}_${random_integer.random-alias.result}"
  snetname = "${terraform.workspace}_${var.snet-name}_${random_integer.random-alias.result}"
  nsgname = "${terraform.workspace}_${var.nsg-name}_${random_integer.random-alias.result}"
  nicname = "${terraform.workspace}_${var.nic-name}_${random_integer.random-alias.result}"
  tag = "${terraform.workspace}"

}

#store tenant ID
data azurerm_client_config current {}

#create brand new RG
resource azurerm_resource_group rg-alias {
  name     = local.rgname
  location = var.location

  tags = {
    environment = local.tag
  }
}

#create brand new st account just for this VM

resource azurerm_storage_account st-alias {
  name                     = local.stname
  resource_group_name      = azurerm_resource_group.rg-alias.name
  location                 = azurerm_resource_group.rg-alias.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = local.tag
  }
  
}

#creation of net and subnets

#Azure VNET

resource azurerm_virtual_network vnet-alias {
  name                = local.vnetname
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-alias.name
  address_space       = ["20.0.0.0/16"]

  tags = {
    environment = local.tag
  }

}

#Azure subnet
  resource azurerm_subnet snet-alias {
  name                 = var.snet-name  
  resource_group_name  = azurerm_resource_group.rg-alias.name
  virtual_network_name = azurerm_virtual_network.terraformVNET.name
  address_prefixes     = ["20.0.2.0/24"]
  
}

#Azure Network Security Group

resource azurerm_network_security_group "TerraNSG" {
  name                = local.nsgname
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-alias.name

  security_rule {
    name                       = "only_allow_machine_IP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
#only allow ip of the machine that creates of terraform
    source_address_prefix      = "${chomp(data.http.myip.body)}/32"
    destination_address_prefix = "*"

}

  tags = {
    environment = local.tag
  }
}

#only allow ip of the machine that creates of terraform
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}


#Public IP configuration
resource "azurerm_public_ip" "PIP" {
  name                = "PIP${random_string.PIP.result}"
  resource_group_name = azurerm_resource_group.rg-alias.name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    environment = local.tag
  }
}

/* #Creation of Log Analytics Workspace

resource azurerm_log_analytics_workspace alias_log {
  name                = var.log-name    
  location            = var.location
  resource_group_name = var.rg-name 
  sku                 = "PerGB2018"
  retention_in_days   = 30

    tags = {
    environment = local.tag
  }

}

data "azurerm_subscription" "current" {
}

resource azurerm_monitor_diagnostic_setting alias_activity_logs {
  name                       = var.diag-name
  target_resource_id         = data.azurerm_subscription.current.id
  storage_account_id         = azurerm_storage_account.st-alias.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.alias_log.id

  enabled_log {
    category = "Administrative"

    retention_policy {
      enabled = false
    }
  }
  enabled_log {
    category = "Security"

    retention_policy {
      enabled = false
    }
  }
  enabled_log {
    category = "ServiceHealth"

    retention_policy {
      enabled = false
    }
  }
  enabled_log {
    category = "Alert"

    retention_policy {
      enabled = false
    }
  }
  enabled_log {
    category = "Recommendation"

    retention_policy {
      enabled = false
    }
  }
  enabled_log {
    category = "Policy"

    retention_policy {
      enabled = false
    }
  }
  enabled_log {
    category = "Autoscale"

    retention_policy {
      enabled = false
    }
  }
  enabled_log {
    category = "ResourceHealth"

    retention_policy {
      enabled = false
    }
  }

}

#creation of the azure key vault


resource azurerm_key_vault kv-alias {
  name                        = var.kv-name
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg-alias.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"


access_policy {
  #key_vault_id = azurerm_key_vault.TerraformKV.id
   tenant_id = data.azurerm_client_config.current.tenant_id
   object_id = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]

}

  tags = {
    environment = var.environment 
  }

}

#configure audit of the KV

resource "azurerm_monitor_diagnostic_setting" "diag-kv-alias" {
  name               = var.kv-name
  target_resource_id = azurerm_key_vault.kv-alias.id
  storage_account_id = azurerm_storage_account.st-alias.id

  enabled_log {
    category = "AuditEvent"

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}
*/