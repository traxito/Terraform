#create NIC for the Linux VM

resource azurerm_network_interface NIC-alias {
  name                = "nic-vm${random_string.NIC.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-alias.name

  ip_configuration {
    name                          = "PIP"
    subnet_id                     = azurerm_subnet.snet-name.id  
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.PIP.id
  }

    tags = {
    environment = "Terraform"
  }
}

#VM configuration

resource azurerm_linux_virtual_machine TerraformLinuxVM {
  name                = "vm${random_integer.TerraformLinuxVM.result}"
  resource_group_name = azurerm_resource_group.rg-alias.name
  location            = var.location
  size                = "Standard_DS2_v2"
  admin_username      = var.username
  network_interface_ids = [
    azurerm_network_interface.NIC.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    environment = "Terraform"
  }

}

#Data block always create a new block!
  data azurerm_key_vault kv-name {
  name                = var.kv-name 
  resource_group_name = var.rg-name
}