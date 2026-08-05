output "container_app_url" {
  value = azurerm_container_app.app.latest_revision_fqdn
}

output "database_host" {
  value = azurerm_postgresql_flexible_server.db.fqdn
}

output "key_vault_uri" {
  value = azurerm_key_vault.main.vault_uri
}

output "resource_group" {
  value = azurerm_resource_group.main.name
}