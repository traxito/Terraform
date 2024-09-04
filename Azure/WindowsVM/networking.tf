
#basic networking attributes
resource azurerm_virtual_network vnet-alias {
  name                = var.vnet-name
  address_space       = ["20.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-alias.name

  tags = {
    environment = local.tag
  }
}

resource azurerm_subnet subnet-alias {
  name                 = var.snet-name
  resource_group_name  = azurerm_resource_group.rg-alias.name
  virtual_network_name = azurerm_virtual_network.vnet-alias.name
  address_prefixes     = ["20.0.2.0/24"]

  
}

resource azurerm_network_security_group nsg-alias {
  name                = var.nsg-name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-alias.name

  security_rule {
    name                   = "only_open_rdp_for_public_ip"
    priority               = 100
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "389"
    #only allow ip of the machine that creates of terraform
    source_address_prefix     = "${chomp(data.http.myip.body)}"
    destination_address_prefix = "*"
  }

  tags = {
    environment = local.tag
  }
}

#only allow ip of the machine that creates of terraform
data http myip {
  url = "http://ipv4.icanhazip.com"
}


resource azurerm_network_interface NIC-alias {
  name                = "nic-vm${random_string.random-name.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-alias.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-alias.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = local.tag
  }

}

resource azurerm_public_ip PIP {
  name                = "PIP${random_string.random-name.result}"
  resource_group_name = azurerm_resource_group.rg-alias.name
  location            = var.location
  allocation_method   = "Dynamic"

  tags = {
    environment = local.tag
  }

  depends_on = [ azurerm_windows_virtual_machine.vm-alias ]
}