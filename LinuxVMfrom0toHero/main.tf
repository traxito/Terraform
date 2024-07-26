#store tenant ID
data "azurerm_client_config" "current" {}

#uses RG already created
data "azurerm_resource_group" "TerraformRG" {
  name = var.rg-name
# since it's already created, it's not needed to set up the location
 # location = var.location 
}

#creation of the azure key vault


resource "azurerm_key_vault" "TerraformKV" {
  name                        = var.kv-name
  location                    = var.location
  resource_group_name         = var.rg-name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"


  #access_policy {
  #  #key_vault_id = azurerm_key_vault.TerraformKV.id
  #  tenant_id = data.azurerm_client_config.current.tenant_id
  #  object_id = data.azurerm_client_config.current.object_id
  #
  #  secret_permissions = [
  #    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  #  ]
  #
  #}
  #
}
  resource azurerm_key_vault_access_policy terraform_user {
    key_vault_id = azurerm_key_vault.TerraformKV.id
    tenant_id    = data.azurerm_client_config.current.tenant_id
    object_id    = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]

}


#dona conflicte:  A data resource "azurerm_resource_group" "id" has not been declared in the root module.
# output "id" {
#   value = data.azurerm_resource_group.id
# }

#creation of net and subnets

resource azurerm_network_security_group "TerraNSG" {
  name                = var.nsg-name
  location            = var.location
  resource_group_name = var.rg-name

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
  name                = var.vnet-name
  location            = var.location
  resource_group_name = var.rg-name
  address_space       = ["20.0.0.0/16"]

}

  resource azurerm_subnet snet-name {
  name                 = var.snet-name  
  resource_group_name  = var.rg-name
  virtual_network_name = var.vnet-name  
  address_prefixes     = ["20.0.2.0/24"]
  
}

#Public IP configuration
resource "azurerm_public_ip" "PIP" {
  name                = "PIP${random_string.PIP.result}"
  resource_group_name = var.rg-name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    environment = "Terraform"
  }
}

#creation of the storage account

resource "azurerm_storage_account" "TerraformStorage" {
    name = var.st-name
    location = var.location
    resource_group_name = var.rg-name
    account_tier             = "Standard"
    account_replication_type = "LRS"

    tags = {
    environment = "Terraform"
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