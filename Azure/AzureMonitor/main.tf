#Terraform code to create Storage account, analytics workspace and export logs to analytics

resource azurerm_resource_group alias_rg {
  name     = var.rg-name    
  location = var.location   
}

resource azurerm_storage_account alias_st {
  name                     = var.st-name    
  resource_group_name      = var.rg-name 
  location                 = var.location  
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "production"
  }
}

#Creation of Log Analytics Workspace

resource azurerm_log_analytics_workspace alias_log {
  name                = var.log-name    
  location            = var.location
  resource_group_name = var.rg-name 
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

data "azurerm_subscription" "current" {
}

resource azurerm_monitor_diagnostic_setting alias_activity_logs {
  name                       = var.diag-name
  target_resource_id         = data.azurerm_subscription.current.id
  storage_account_id         = azurerm_storage_account.alias_st.id
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

