variable "rg-name" {
    type        = string
    description = "Name of the resource group"
  
}

variable "location" {
     type        = string
     description = "location"
}

variable "st-name" {
    type        = string
    description = "Name of the storage account"
}

variable "stc-name" {
    type = string
    description = "Name of the container inside storage account"
  
}