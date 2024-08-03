terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.113.0"
    }
  }

    backend "azurerm" {
    resource_group_name  = azurerm_resource_group.rg-name.name  # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = azurerm_storage_account.st-name.name                     # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = azurerm_storage_container.stc-name.name
#key is just the name that the tfstate file will have
    key                  = "tfstate"       # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}

provider "azurerm" {
    features {
      
    }
  # Configuration options
}