terraform {
  cloud {
    organization = "AlexMontesinos"
    workspaces {
      name = "Terraform"
    }
  }
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "4.0.5"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.113.0"
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

provider "tls" {
  # Configuration options
}

provider "azurerm" {
    features {
      key_vault {
        purge_soft_delete_on_destroy    = true
        recover_soft_deleted_key_vaults = true
        }
    }
}

provider "random" {
  # Configuration options
}

provider "http" {
  # Configuration options
}
