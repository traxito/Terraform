#random string for NIC

resource random_string NIC {
  length           = 8
  upper            = false
  special          = false
}

#random string for PIP

resource random_string PIP {
  length           = 8
  upper            = false
  special          = false
}

#random string for VMname

resource "random_integer" "TerraformLinuxVM" {
  min = 1
  max = 50000
}


variable "azurerm_resource_group" {
  default     = "terraformRG"
  description = "Name of the RG"
}

variable "resource_group_location" {
  type        = string
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "azureadmin"
}

variable "azurerm_network_security_group" {
  default     = terraformNSG
  type        = string
  description = "Name of the NSG for terraform resources"
}

variable "azurerm_virtual_network" {
  default     = "terraformVNET"
  type        = string
  description = "Name of the VNET for terraform resources"
}

variable "azurerm_storage_account" {
  default     = "terraformStorageAccount"
  type        = string
  description = "Name of the storage account for terraform resources"
}


variable "azurerm_log_analytics_workspace" {
  default     = "terraformLogAnalytics"
  type        = string
  description = "Name of the Log analytics for terraform resources"
}

variable "azurerm_key_vault" {
  default     = "TerraformKeyVault"
  type        = string
  description = "Name of the Log analytics for terraform resources"
}