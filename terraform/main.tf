terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.30.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_linux_virtual_machine" "vm" {
  admin_username = "IAmRoot"
  location = azurerm_resource_group.tobby.location
  name = "DuckAPI-VM"
  network_interface_ids = [azurerm_network_interface.vm_interface.id]
  resource_group_name = azurerm_resource_group.tobby.name
  size = "Standard_F2"
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "IAmRoot"
    public_key = file("~/.ssh/id_rsa.pub")
  }

}

resource "azurerm_network_interface" "vm_interface" {
  name                = "vm-network-interface"
  location            = azurerm_resource_group.tobby.location
  resource_group_name = azurerm_resource_group.tobby.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }
}

resource "azurerm_public_ip" "ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.tobby.location
  resource_group_name = azurerm_resource_group.tobby.name
  allocation_method   = "Dynamic"
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.tobby.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tobby.location
  resource_group_name = azurerm_resource_group.tobby.name
}

resource "azurerm_resource_group" "tobby" {
  name     = "tobbyDuck"
  location = "West Europe"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.tobby.location
  resource_group_name = azurerm_resource_group.tobby.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.vm_interface.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}
