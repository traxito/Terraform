variable rg-name {
  type        = string
  description = "Name of the Resource Group for terraform resources"
}

variable location {
  type        = string
  description = "Location of the Resource Group for terraform resources"
}

variable st-name {
    type = string
    description = "CAUTION only lower case!!"
}

variable log-name {
    type = string
    description = "Caution alphanumeric only! Name of the Analytics Workspace"
}

variable diag-name {
    type = string
    description = "Name of the monitor_diagnostic_setting"
}