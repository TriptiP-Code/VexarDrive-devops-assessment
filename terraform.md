# Terraform Infrastructure

This directory provisions the production infrastructure for the Vexar Fleet Ping Service.

## Components

- Azure Resource Group
- Azure Virtual Network
- Azure Container Apps
- Azure Database for PostgreSQL Flexible Server
- Azure Key Vault
- Azure Managed Identity
- Azure Log Analytics Workspace

## Design Decisions

- Azure Container Apps selected instead of AKS due to lower operational overhead for a single containerized service.
- PostgreSQL deployed as Azure Database for PostgreSQL Flexible Server.
- Secrets stored in Azure Key Vault.
- Managed Identity used for secure access to Azure services.
- Infrastructure organized into separate Terraform modules/files for maintainability.
- Log Analytics integrated for centralized monitoring.