variable "rg-name" {
  type        = string
  description = "Name of the Resource Group for terraform resources"
}

variable "location" {
  type        = string
  description = "Location of the Resource Group for terraform resources"
}

variable st-name {
    type = string
    description = "CAUTION only lower case!!"
}

variable kv-name {
    type = string
    description = "Name for the key vault"
}