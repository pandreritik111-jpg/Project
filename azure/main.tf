provider "azurerm" {
  features {}
}
 
# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "prashant-rg"
  location = "Australia East"
}
 
# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "prashant-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
 
# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
 
# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "prashant-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
 
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
 
# Windows VM (2025)
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "prashant-win-az"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2ats_v2"
 
  admin_username = "azureuser"
  admin_password = "Password@1234!"
 
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
 
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
 
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2025-datacenter"
    version   = "latest"
  }
}
