
#uses RG already created

data "azurerm_resource_group" "TerraformRG" {
  name = var.azurerm_resource_group.default
  location = var.resource_group_location.default

      tags = {
    environment = "Terraform"
  }
}

output "id" {
  value = data.var.azurerm_resource_group.id
}

#creation of net and subnets

resource azurerm_network_security_group "TerraNSG" {
  name                = var.azurerm_network_security_group.default
  location            = var.resource_group_location.default
  resource_group_name = var.azurerm_resource_group.default

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
    environment = "Terraform"
  }
}

#only allow ip of the machine that creates of terraform
#dat module always new block!!
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

#Azure VNET

resource azurerm_virtual_network "terraformVNET" {
  name                = var.azurerm_virtual_network.default
  location            = var.resource_group_location.default
  resource_group_name = var.azurerm_resource_group.default
  address_space       = ["20.0.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "20.0.2.0/24"
    security_group = var.azurerm_network_security_group.default
  }

  tags = {
    environment = "Terraform"
  }
}

#Public IP configuration
resource "azurerm_public_ip" "PIP" {
  name                = "PIP${random_string.PIP.result}"
  resource_group_name = var.azurerm_resource_group.default
  location            = var.resource_group_location.default
  allocation_method   = "Static"

  tags = {
    environment = "Terraform"
  }
}

#creation of the storage account

resource "azurerm_storage_account" "TerraformStorage" {
    name = var.azurerm_storage_account.default
    location = var.resource_group_location.default
    resource_group_name = var.resource_group_name.default
    account_tier             = "Standard"
    account_replication_type = "LRS"

    tags = {
    environment = "Terraform"
  }

}

#creation of the azure key vault

resource "azurerm_key_vault" "TerraformKV" {
  name                        = var.azurerm_key_vault.default
  location                    = var.resource_group.default
  resource_group_name         = var.resource_group.default
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

#Aqui el codi es diferent al exemple que teniM
#data azurerm_client_config current {}

  access_policy {
    #key_vault_id = azurerm_key_vault.var.azurerm_key_vault.id
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"
    ]

    secret_permissions = [
      "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
    ]

    storage_permissions = [
      "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"
    ]
  }
}

#creation of log analitics

#resource "azurerm_log_analytics_workspace" "var.azurerm_log_analytics_workspace" {
#  name                = var.azurerm_log_analytics_workspace
#  location            = var.resource_group.location
#  resource_group_name = var.resource_group.name
#  sku                 = "PerGB2018"
#  retention_in_days   = 30
#}

# resource random_string keyvault_monitor {
#   length           = 8
#   upper            = false
#   special          = false
# }# 

# locals {
#   monitor_suffix = "a6ipu10e"
# }
# data azurerm_storage_account monitor {
#   name                = "st${local.monitor_suffix}"
#   resource_group_name = "rg-ep1-${local.monitor_suffix}"
# }
# data azurerm_log_analytics_workspace monitor {
#   name                = "log-ep1-${local.monitor_suffix}"
#   resource_group_name = "rg-ep1-${local.monitor_suffix}"
# }# 

# resource azurerm_monitor_diagnostic_setting activity_logs {
#   name                       = "diag-${random_string.keyvault_monitor.result}"
#   target_resource_id         = azurerm_key_vault.main.id
#   storage_account_id         = data.azurerm_storage_account.monitor.id
#   log_analytics_workspace_id = data.azurerm_log_analytics_workspace.monitor.id# 

#   log {
#     category_group = "audit"# 

#     retention_policy {
#       enabled = false
#     }
#   }
#   log {
#     category_group = "allLogs"# 

#     retention_policy {
#       enabled = false
#     }
#   }
#   metric {
#     category = "AllMetrics"# 

#     retention_policy {
#       enabled = false
#     }
#   }