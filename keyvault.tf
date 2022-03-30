
resource "azurerm_key_vault" "kv" {
  name                        = "kv-fw-demo-jk-2022"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  purge_protection_enabled    = false
  enable_rbac_authorization   = true

  sku_name = "standard"
  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = [azurerm_public_ip.ubuntu.ip_address,  "155.4.130.187/32", "98.128.167.12/32"]
  }
}


resource "azurerm_key_vault_certificate" "democert" {
  name         = "demo"
  key_vault_id = azurerm_key_vault.kv.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = ["demo.com", "www.demo.com"]
      }

      subject            = "CN=demo"
      validity_in_months = 12
    }
  }
}

resource "azurerm_role_assignment" "appgwaccess" {
  principal_id         = azurerm_user_assigned_identity.appgw.principal_id
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key vault administrator"
}

resource "azurerm_role_assignment" "useraccess" {
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key vault administrator"
}
# resource "azurerm_key_vault_secret" "example" {
#   name         = "secret-sauce"
#   value        = "szechuan"
#   key_vault_id = azurerm_key_vault.kv.id
# }
