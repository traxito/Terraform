#mirar el video: https://www.youtube.com/watch?v=_ntiohUA-QA

#random name for VM

resource random_string random-name {
    length = 4
    special = false
    lower = true
    min_lower = 4
}

resource "random_integer" "random-alias" {
  min = 1
  max = 5000
}

#Template for basic Windows VM

resource azurerm_resource_group rg-alias {
  name     = var.rg-name[random_string.random-name.result]
  location = var.location
}

resource "azurerm_storage_account" "st-alias" {
  name                     = var.st-name[random_string.random-name.result]
  resource_group_name      = azurerm_resource_group.rg-alias.name
  location                 = azurerm_resource_group.rg-alias.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "developer"
  }
  
}
#we tell Terraform to connect to KV

data "azurerm_key_vault" "kv-alias" {
  name                = "kv-principal-Deltalab"
  resource_group_name = "kv-rg"
}

#reference to already created admin username and password on KV

data "azurerm_key_vault_secret" "kv-secret-alias" {
  name         = "windows-local-admin-account"
  key_vault_id = data.azurerm_key_vault.kv-alias.id
}

data "azurerm_key_vault_secret" "kv-secret-alias-2" {
  name         = "windows-local-account-password"
  key_vault_id = data.azurerm_key_vault.kv-alias.id
}

resource azurerm_windows_virtual_machine vm-alias {
  name                = var.vm-name[random_string.random-name.result]
  resource_group_name = azurerm_resource_group.rg-alias.name
  location            = var.location
  size                = "Standard_B2s"
#reference to already created admin username and password on KV
  admin_username      = data.azurerm_key_vault_secret.kv-secret-alias.value
  admin_password      = data.azurerm_key_vault_secret.kv-secret-alias-2.value
  enable_automatic_updates = false
  hotpatching_enabled = false
#Specifies the type of on-premise license (also known as Azure Hybrid Use Benefit) which should be used for this Virtual Machine. Possible values are None, Windows_Client and Windows_Server
  license_type = "Windows_Server"
#Specifies the reboot setting for platform scheduled patching, "Always" "IfRequired" "Never"
  reboot_setting = "Never"
#Specifies if Secure Boot and Trusted Launch is enabled for the Virtual Machine. Changing this forces a new resource to be created.
  secure_boot_enabled = true
#Specifies the Time Zone which should be used by the Virtual Machine: Romance Standard Time (UTC+1 Madrid)
  timezone = "Romance Standard Time"
#Whether to enable the hibernation capability or not
  additional_capabilities {
     hibernation_enabled = false
  }

  network_interface_ids = [
    azurerm_network_interface.NIC-alias.id,
  ]

  os_disk {
    caching              = "ReadWrite"
#The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS and Premium_ZRS
    storage_account_type = "StandardSSD_LRS"
#(Optional) The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from.
    disk_size_gb = 120
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  depends_on = [
    data.azurerm_key_vault.kv-alias
  ]
}