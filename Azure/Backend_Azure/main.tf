#create of the resources for save the tfstate file of Terraform on Azure st and share the stat with members

resource azurerm_resource_group rg-alias {
  name     = var.rg-name
  location = var.location
}

resource azurerm_storage_account st-alias {
  name                     = var.st-name
  resource_group_name      = azurerm_resource_group.rg-alias.name
  location                 = azurerm_resource_group.rg-alias.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Terraform Backend"
  }
  
}

resource azurerm_storage_container stc-alias {
  name                  = var.stc-name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"

}