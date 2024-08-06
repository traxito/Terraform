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
}
}

provider "azurerm" {
    features {
      
    }
  # Configuration options" {
 
 } 

 provider "random" {
  # Configuration options
}