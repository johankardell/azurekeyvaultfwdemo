resource "azurerm_virtual_network" "sample" {
  location            = azurerm_resource_group.rg.location
  name                = "vnet-kv-sample"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["192.168.0.0/24"]
}

resource "azurerm_subnet" "iaas" {
  name                 = "subnet-iaas"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.sample.name
  address_prefixes     = ["192.168.0.0/24"]
  # service_endpoints    = ["Microsoft.KeyVault"]
}

resource "azurerm_network_security_group" "iaas" {
  name                = "nsg-iaas"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "185.213.154.230"
    destination_address_prefix = "*"
  }
}
