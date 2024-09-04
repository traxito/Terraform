
data azurerm_client_config current {}

#create brand new RG
#name bust me UNIQUE and not random
resource azurerm_resource_group rg-alias {
  name     = var.rg-name
  location = var.location
}

#create a st account
#name bust me UNIQUE and not random
resource azurerm_storage_account st-alias {
  name                     = var.st-name
  resource_group_name      = azurerm_resource_group.rg-alias.name
  location                 = azurerm_resource_group.rg-alias.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    kv = "st account"
  }

}

#Creation of Log Analytics Workspace

resource azurerm_log_analytics_workspace alias_log {
  name                = var.log-name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-alias.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

data azurerm_subscription current {
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
  name                       = var.kv-name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg-alias.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  sku_name = "standard"


  access_policy {
    #key_vault_id = azurerm_key_vault.TerraformKV.id
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
    ]

  }

}

#configure audit of the KV

resource azurerm_monitor_diagnostic_setting diag-kv-alias {
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