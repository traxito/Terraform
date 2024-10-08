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

variable rg-name {
  type        = string
  description = "Name of the RG"
  }


variable location {
  type        = string
  description = "Location of the resource group."
}

variable username {
  type        = string
  description = "The username for the local account that will be created on the new VM."
}

variable nsg-name {
  type        = string
  description = "Name of the NSG for terraform resources"
}

variable vnet-name {
  type        = string
  description = "Name of the VNET for terraform resources"
}

variable st-name {
  type        = string
  description = "Name of the storage account for terraform resources"
}

variable log-name {
  type        = string
  description = "Name of the Log analytics for terraform resources"
}

variable kv-name {
  type        = string
  description = "Name of the Log analytics for terraform resources"
}

variable snet-name {
  type        = string
  description = "Name of the subnet for terraform resources"
}

variable diag-name {
    type = string
    description = "Name of the monitor_diagnostic_setting"
}

variable environment{
  type = string
  description = "name of the environtment of the AzDevOps Agent"
}

variable vm-name {
  type = string
  description = "name of the Linux VM"
  
}