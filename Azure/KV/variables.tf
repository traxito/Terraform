variable "rg-name" {
  type        = string
  description = "Name of the Resource Group for terraform resources"
}

variable "location" {
  type        = string
  description = "Location of the Resource Group for terraform resources"
}

variable "st-name" {
  type        = string
  description = "CAUTION only lower case!!"
}

variable "kv-name" {
  type        = string
  description = "Name for the key vault"
}

variable "diag-name" {
  type        = string
  description = "Name of the monitor_diagnostic_setting"
}

variable "environment" {
  type        = string
  description = "name of the environtment of the AzDevOps Agent"
}

variable "log-name" {
  type        = string
  description = "Name of the Log analytics for terraform resources"
}