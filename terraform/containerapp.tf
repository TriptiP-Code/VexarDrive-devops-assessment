resource "azurerm_container_app_environment" "main" {

  name                       = "fleet-env"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name

  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
}

resource "azurerm_container_app" "app" {

  name                         = "fleet-ping-service"
  resource_group_name          = azurerm_resource_group.main.name
  container_app_environment_id = azurerm_container_app_environment.main.id

  revision_mode = "Single"

  template {

    container {

      name   = "fleet-api"
      image  = var.container_image
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "DB_HOST"
        value = azurerm_postgresql_flexible_server.db.fqdn
      }

      env {
        name  = "DB_NAME"
        value = var.database_name
      }
    }

    min_replicas = 1
    max_replicas = 5
  }

  ingress {

    external_enabled = true

    target_port = 3000

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app.id]
  }
}