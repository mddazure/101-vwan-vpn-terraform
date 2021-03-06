provider "azurerm" {
version = "=2.0"
features {}
}
# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "vwan-terraform-rg"
  location = "West Europe"
}
#Create a virtual wan
resource "azurerm_virtual_wan" "demo-vwan" {
  name                = "demo-vwan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}
#Create a virtual hub & gateway
resource "azurerm_virtual_hub" "demo-vwan-hub" {
  name                = "demo-vwan-hub"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_virtual_wan.demo-vwan.location
  virtual_wan_id      = azurerm_virtual_wan.demo-vwan.id
  address_prefix      = "192.168.0.0/24"
}
resource "azurerm_vpn_gateway" "demo-vwan-hub-vpngw" {
  name                = "demo-vwan-hub-vpngw"
  location            = azurerm_virtual_hub.demo-vwan-hub.location
  resource_group_name = azurerm_resource_group.rg.name
  virtual_hub_id      = azurerm_virtual_hub.demo-vwan-hub.id
  #public ip address of vpn gateway is not exposed, can only be retrieved from exported site configuration file after creation of gateway
  #it is therefore not possible to automate vpn-gateway to vnet-gateway s2s vpn connection
}

#support for vwan child resources (hub-vnet connections etc) in azure_rm provider is in development, see https://github.com/terraform-providers/terraform-provider-azurerm/issues/3279
#https://github.com/terraform-providers/terraform-provider-azurerm/pull/5004


# Create a virtual network within the resource group
resource "azurerm_virtual_network" "spoke1" {
  name                = "spoke1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["172.16.1.0/24"]
  
}
resource "azurerm_subnet" "spoke1-subnet1"{
      name = "subnet1"
      resource_group_name = azurerm_resource_group.rg.name
      virtual_network_name = azurerm_virtual_network.spoke1.name
      address_prefix = "172.16.1.0/26"
  }
  resource "azurerm_subnet" "spoke1-subnet2"{
      name = "subnet2"
      resource_group_name = azurerm_resource_group.rg.name
      virtual_network_name = azurerm_virtual_network.spoke1.name
      address_prefix = "172.16.1.64/26"
  }
 
  resource "azurerm_subnet" "spoke1-bastionsubnet"{
      name = "AzureBastionSubnet"
      resource_group_name = azurerm_resource_group.rg.name
      virtual_network_name = azurerm_virtual_network.spoke1.name
            address_prefix = "172.16.1.224/28"
  }

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "spoke2" {
  name                = "spoke2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["172.16.2.0/24"]
  
}
resource "azurerm_subnet" "spoke2-subnet1"{
      name = "subnet1"
      resource_group_name = azurerm_resource_group.rg.name
      virtual_network_name = azurerm_virtual_network.spoke2.name
      address_prefix = "172.16.2.0/26"
  }
  resource "azurerm_subnet" "spoke2-subnet2"{
      name = "subnet2"
      resource_group_name = azurerm_resource_group.rg.name
      virtual_network_name = azurerm_virtual_network.spoke2.name
      address_prefix = "172.16.2.64/26"
  }
  resource "azurerm_subnet" "spoke2-bastionsubnet"{
      name = "AzureBastionSubnet"
      resource_group_name = azurerm_resource_group.rg.name
      virtual_network_name = azurerm_virtual_network.spoke2.name
            address_prefix = "172.16.2.224/28"
  }

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "spoke3" {
  name                = "spoke3"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["172.16.3.0/24"]
  
}
resource "azurerm_subnet" "spoke3-subnet1"{
      name = "subnet1"
      resource_group_name = azurerm_resource_group.rg.name
      virtual_network_name = azurerm_virtual_network.spoke3.name
      address_prefix = "172.16.3.0/26"
  }
  resource "azurerm_subnet" "spoke3-subnet2"{
      name = "subnet2"
      resource_group_name = azurerm_resource_group.rg.name
      virtual_network_name = azurerm_virtual_network.spoke3.name
      address_prefix = "172.16.3.64/26"
  }
# Create a virtual network within the resource group
resource "azurerm_virtual_network" "spoke4" {
  name                = "spoke4"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["172.16.4.0/24"]
  
}
resource "azurerm_subnet" "spoke4-subnet1"{
      name = "subnet1"
      resource_group_name = azurerm_resource_group.rg.name
      virtual_network_name = azurerm_virtual_network.spoke4.name
      address_prefix = "172.16.4.0/26"
  }
resource "azurerm_subnet" "spoke4-subnet2"{
      name = "subnet2"
      resource_group_name = azurerm_resource_group.rg.name
      virtual_network_name = azurerm_virtual_network.spoke4.name
      address_prefix = "172.16.4.64/26"
  }
resource "azurerm_subnet" "spoke4-bastionsubnet"{
      name = "AzureBastionSubnet"
      resource_group_name = azurerm_resource_group.rg.name
      virtual_network_name = azurerm_virtual_network.spoke4.name
      address_prefix = "172.16.4.224/28"
  }


# Create a virtual network within the resource group
resource "azurerm_virtual_network" "onprem" {
  name                = "onprem"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "northeurope"
  address_space       = ["10.0.1.0/24"]
  
}
resource "azurerm_subnet" "onprem-subnet1"{
      name = "subnet1"
      resource_group_name = azurerm_resource_group.rg.name
      virtual_network_name = azurerm_virtual_network.onprem.name
      address_prefix = "10.0.1.0/26"
  }
resource "azurerm_subnet" "onprem-subnet2"{
      name = "subnet2"
      resource_group_name = azurerm_resource_group.rg.name
      virtual_network_name = azurerm_virtual_network.onprem.name
      address_prefix = "10.0.1.0/26"
  }
resource "azurerm_subnet" "onprem-GatewaySubnet"{
      name = "GatewaySubnet"
      resource_group_name = azurerm_resource_group.rg.name
      virtual_network_name = azurerm_virtual_network.onprem.name
            address_prefix = "10.0.1.240/28"
}
resource "azurerm_subnet" "onprem-bastionsubnet"{
      name = "AzureBastionSubnet"
      resource_group_name = azurerm_resource_group.rg.name
      virtual_network_name = azurerm_virtual_network.onprem.name
      address_prefix = "172.16.4.224/28"
  }


resource "azurerm_public_ip" "onprem-gw-pubip" {
  name                = "onprem-gw-pubip"
  location            = azurerm_virtual_network.onprem.location
  resource_group_name = azurerm_resource_group.rg.name

  allocation_method = "Dynamic"
}
resource "azurerm_virtual_network_gateway" "qonprem-gw" {
  name                = "qonprem-gw"
  location            = azurerm_virtual_network.onprem.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "onprem-gwGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.onprem-gw-pubip.id
    subnet_id                     = azurerm_subnet.onprem-GatewaySubnet.id
  }
}

#create network interfaces
resource "azurerm_network_interface" "vwan1-nic" {
  name                = "vwan1-nic"
  location            = azurerm_virtual_network.spoke1.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke1-subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "onprem-nic" {
  name                = "onprem-nic"
  location            = azurerm_virtual_network.onprem.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.onprem-subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}
#create vms
resource "azurerm_linux_virtual_machine" "vwan1" {
  name                = "vwan1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_virtual_network.spoke1.location
  size                = "Standard_D2s_v3"
  admin_username      = "marc"
  disable_password_authentication = false
   admin_password = "Nienke040598"
  network_interface_ids = [
    azurerm_network_interface.vwan1-nic.id,
  ]
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
resource "azurerm_linux_virtual_machine" "onprem" {
  name                = "qremote"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_virtual_network.onprem.location
  size                = "Standard_D2s_v3"
  admin_username      = "marc"
  disable_password_authentication = false
   admin_password = "Nienke040598"
  network_interface_ids = [
    azurerm_network_interface.onprem-nic.id,
  ]
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
#create bastion
resource "azurerm_public_ip" "onprem-bastion-pubip" {
  name                = "onprem-bastion-pubip"
  location            = azurerm_virtual_network.onprem.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"
  allocation_method = "Static"
}
resource "azurerm_public_ip" "spoke1-bastion-pubip" {
  name                = "spoke1-bastion-pubip"
  location            = azurerm_virtual_network.spoke1.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"
  allocation_method = "Static"
}
resource "azurerm_bastion_host" "spoke1-bastion" {
  name                = "spoke1-bastion"
  location            = azurerm_virtual_network.spoke1.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.spoke1-bastionsubnet.id
    public_ip_address_id = azurerm_public_ip.spoke1-bastion-pubip.id
  }
}
resource "azurerm_bastion_host" "qremote-bastion" {
  name                = "qremote-bastion"
  location            = azurerm_virtual_network.onprem.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.onprem-bastionsubnet.id
    public_ip_address_id = azurerm_public_ip.onprem-bastion-pubip.id
  }
}