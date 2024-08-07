variable "rg-name" {
    type = map(string)
    default = {
      "name" = "vmname"
    }
}

variable "location" {
    type = string
    description = "Location of the VM"
  
}

variable "vm-name" {
    type = string
    description = "name of the vm"
  
}

variable st-name {
    type = map(string)
    default = {
      "name" = "tfwindowsstaccount"
    }
}

variable "snet-name" {
  type        = string
  description = "Name of the subnet for terraform resources"
}

variable environment{
  type = string
  description = "name of the environtment of the AzDevOps Agent"
}

variable "nsg-name" {
  type        = string
  description = "Name of the NSG for terraform resources"
}

variable "vnet-name" {
  type        = string
  description = "Name of the VNET for terraform resources"
}