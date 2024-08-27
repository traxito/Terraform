#create NIC for the Linux VM

resource azurerm_network_interface nic-alias {
  name                = local.nicname
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-alias.name

  ip_configuration {
    name                          = "PIP"
    subnet_id                     = azurerm_subnet.snet-name.id  
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.PIP.id
  }
    tags = {
    environment = local.tag
  }
}

#Get access to KV and push the public ssh key

data azurerm_key_vault kv-alias {
  name                = azurerm_key_vault.kv-alias.name
  resource_group_name = azurerm_resource_group.rg-alias.name
}
data azurerm_key_vault_secret ssh_public_key {
  name         = "ssh-public"
  key_vault_id = data.azurerm_key_vault.kv-alias.id
}

#VM configuration

resource azurerm_linux_virtual_machine vm-name {
  name                = local.vmname
  resource_group_name = azurerm_resource_group.rg-alias.name
  location            = var.location
  size                = "Standard_DS2_v2"
  admin_username      = var.username
  network_interface_ids = [
    azurerm_network_interface.NIC-alias.id,
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
  admin_ssh_key {
    username   = var.username
    public_key = data.azurerm_key_vault_secret.ssh_public_key.value
  }
  tags = {
    environment = local.tag
  }
#execute a script inside the VM

  provisioner "file" {
    source      = "prepare_linux_agent.sh"
    destination = "/tmp/prepare_linux_agent.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/prepare_linux_agent.sh",
      "/tmp/prepare_linux_agent.sh",
    ]
  }


}


