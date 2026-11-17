resource "azurerm_public_ip" "web" {
  name                = "project3-web-pip"
  resource_group_name = azurerm_resource_group.project.name
  location            = azurerm_resource_group.project.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "web" {
  name                = "project3-web-nic"
  resource_group_name = azurerm_resource_group.project.name
  location            = azurerm_resource_group.project.location

  ip_configuration {
    name                          = "web"
    subnet_id                     = module.network.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web.id
  }
}

resource "azurerm_linux_virtual_machine" "web" {
  name                = "project3-web-vm"
  resource_group_name = azurerm_resource_group.project.name
  location            = azurerm_resource_group.project.location
  size                = "Standard_B2s_v2"
  admin_username      = "azureuser"

  network_interface_ids = [azurerm_network_interface.web.id]
  custom_data           = filebase64("${path.module}/cloud-init.yaml")

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(pathexpand("~/.ssh/project3.pub"))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

resource "azurerm_network_security_rule" "http" {
  name                        = "Allow-HTTP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.project.name
  network_security_group_name = "project3-web-nsg"

  depends_on = [module.network]
}

output "web_url" {
  value = "http://${azurerm_public_ip.web.ip_address}"
}