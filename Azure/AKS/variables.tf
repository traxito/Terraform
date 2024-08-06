variable "location" {
    type        = string
    description = "default value for location"
  
}

variable "rg-name" {
    type = map(srting)
        default = {
          rg-name = "aks_rg_name"
        }
    description = "Name of the RG"
  
}

variable "aks-name" {
    type        = string
    description = "name of the aks cluster"
  
}

variable "dns-prefix" {
    type        = string
    description = "value for DNS prefix"
  
}

variable "node-pool-name" {
    type        = string
    description = "name of the node pool"
  
}

variable "tags-name" {
    type    = map(string)
    default = ["Dev", "Quality", "Prod"]
}