resource "azurerm_user_assigned_identity" "app" {

  name                = "fleet-app-identity"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_key_vault" "main" {

  name                = "vexarfleetkeyvault"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = "standard"
}

data "azurerm_client_config" "current" {}