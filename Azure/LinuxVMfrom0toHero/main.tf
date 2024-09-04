#We will make this TF plan to be independent from other TF's, to be able to work alone

##per provar!!
#variable per ep7
#locals {
#  name = "ep7" <---var.locals
#}
# name     = "rg-${local.name}-${random_string.main.result}"
#S
# també mirar ${terraform.workspace} com a variable canviant de workspace segons sigui Dev Prod etc!

#store tenant ID
data azurerm_client_config current {}

#variables for unique names

resource random_string random-name {
  length    = 3
  special   = false
  lower     = true
  min_lower = 3
}

resource random_integer random-alias {
  min = 1
  max = 5000
}

locals {
  rgname = "${terraform.workspace}_${var.rg-name}_${random_integer.random-alias.result}"
  stname = "${terraform.workspace}${var.st-name}${random_integer.random-alias.result}"
  vmname = "${terraform.workspace}_${var.vm-name}_${random_integer.random-alias.result}"
  tag = "${terraform.workspace}"

}

#create brand new RG
resource azurerm_resource_group rg-alias {
  name     = local.rgname
  location = var.location

    tags = {
    environment = local.tag
  }
}


#create brand new st account just for this VM

resource azurerm_storage_account st-alias {
  name                     = local.stname
  resource_group_name      = azurerm_resource_group.rg-alias.name
  location                 = azurerm_resource_group.rg-alias.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = local.tag
  }
  
}

#creation of net and subnets

#Azure VNET

resource azurerm_virtual_network vnet-alias {
  name                = var.vnet-name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-alias.name
  address_space       = ["20.0.0.0/16"]

    tags = {
    environment = local.tag
  }
}

#Azure subnet

  resource azurerm_subnet snet-name {
  name                 = var.snet-name  
  resource_group_name  = azurerm_resource_group.rg-alias.name
  virtual_network_name = azurerm_virtual_network.terraformVNET.name
  address_prefixes     = ["20.0.2.0/24"]
  
}

#Azure Network Security Group

resource azurerm_network_security_group nsg-alias {
  name                = var.nsg-name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-alias.name

  security_rule {
    name                       = "only_allow_machine_IP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
#only allow ip of the machine that creates of terraform
    source_address_prefix      = "${chomp(data.http.myip.body)}/32"
    destination_address_prefix = "*"

}

    tags = {
    environment = local.tag
  }
}

#only allow ip of the machine that creates of terraform
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}


#Public IP configuration

resource azurerm_public_ip PIP {
  name                = "PIP${random_string.PIP.result}"
  resource_group_name = azurerm_resource_group.rg-alias.name
  location            = var.location
  allocation_method   = "Dynamic"

  tags = {
    environment = local.tag
  }
}