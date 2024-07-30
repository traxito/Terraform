
data "azurerm_client_config" "current" {}

resource azurerm_resource_group rg-alias {
    name = var.rg-name  
    location = var.location 
}

resource "azurerm_storage_account" "alias_st" {
  name                     = var.st-name    
  resource_group_name      = var.rg-name 
  location                 = var.location  
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Development"
  }
}

#RG and storage account are already created on the AzureMonitor TF part (folder)
resource "azurerm_key_vault" "kv-alias" {
  name                        = var.kv-name 
  location                    = var.location
  resource_group_name         = var.rg-name 
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

   # key_permissions = [
   #   "Get",
   # ]

    #since we are only going to use secret permisions to see and retrieve SSH keys, we only need these one

    secret_permissions = [
      "Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore"
    ]

    # storage_permissions = [
    #   "Get",
    # ]
  }
}


#configure audit of the KV

resource "azurerm_monitor_diagnostic_setting" "diag-kv-alias" {
  name               = var.kv-name
  target_resource_id = azurerm_key_vault.kv-alias.id
  storage_account_id = azurerm_storage_account.alias_st.id

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