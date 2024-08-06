terraform {
  cloud {
    organization = "AlexMontesinos"
    workspaces {
      name = "Terraform"
    }
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.114.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.2"
    }
    http = {
      source = "hashicorp/http"
      version = "3.4.3"
    }
  }
}

provider "azurerm" {
    features {
      key_vault {
        }
      
    }
  # Configuration options
}

provider "random" {
  
}