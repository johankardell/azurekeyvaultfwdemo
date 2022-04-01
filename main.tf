resource "azurerm_resource_group" "rg" {
  name     = "keyvault-demo"
  location = "West Europe"
}

resource "azurerm_role_assignment" "ubuntuaccess" {
  principal_id         = azurerm_linux_virtual_machine.ubuntu.identity[0].principal_id
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Reader"
}

data "azurerm_client_config" "current" {}

output "ubuntupublicip" {
  value = azurerm_public_ip.ubuntu.ip_address
}

output "appgwpublicip" {
  value = azurerm_public_ip.appgw.ip_address
}