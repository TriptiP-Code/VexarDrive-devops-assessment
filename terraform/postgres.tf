resource "azurerm_postgresql_flexible_server" "db" {

  name                = "vexar-postgres"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password

  version = "15"

  sku_name = "B_Standard_B1ms"

  storage_mb = 32768

  delegated_subnet_id = azurerm_subnet.database.id

  zone = "1"
}

resource "azurerm_postgresql_flexible_server_database" "app" {

  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.db.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}