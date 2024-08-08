
variable "rg-name" {
  type        = string
  description = "Location of the VM"

}

variable "location" {
  type        = string
  description = "Location of the VM"

}

variable "vm-name" {
  type        = string
  description = "Location of the VM"

}

variable "st-name" {
  type        = string
  description = "Location of the VM"

}

variable "snet-name" {
  type        = string
  description = "Name of the subnet for terraform resources"
}

variable "nsg-name" {
  type        = string
  description = "Name of the NSG for terraform resources"
}

variable "vnet-name" {
  type        = string
  description = "Name of the VNET for terraform resources"
}