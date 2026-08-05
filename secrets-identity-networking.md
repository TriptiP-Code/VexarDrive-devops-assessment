# Secrets, Identity & Networking

## Overview

The application should follow security best practices by ensuring that secrets are never stored in source code or container images. Azure-native identity and networking services should be used to securely authenticate application components and protect internal resources.

---

# 1. Application Secrets

## Current State

During the initial repository review, sensitive configuration such as database credentials and JWT secrets were exposed within the repository.

This presents several production risks:

- Secret leakage through source control
- Credential reuse
- Unauthorized database access
- Difficult secret rotation

## Improvement

Application secrets should be stored outside the application code.

Examples include:

- Database credentials
- JWT secret
- Azure Container Registry credentials
- Third-party API keys

Local development uses a `.env` file, while production retrieves secrets securely from Azure Key Vault.

---

# 2. Azure Key Vault

Azure Key Vault should act as the centralized secret management service.

Secrets stored include:

- Database username
- Database password
- JWT signing key
- Container Registry credentials
- Other application secrets

Benefits include:

- Centralized secret management
- Secret versioning
- Automatic rotation support
- Access auditing
- Reduced risk of accidental exposure

No secrets should be committed to GitHub or embedded in Docker images.

---

# 3. Managed Identity

The Azure Container App should use a System Assigned Managed Identity.

Instead of storing credentials inside the application, Azure automatically provides an identity to the running container.

Authentication flow:

Azure Container App

↓

Managed Identity

↓

Azure Key Vault

↓

Application receives required secrets

Advantages:

- No stored credentials
- Automatic credential rotation
- Improved security
- Native Azure authentication

---

# 4. Role-Based Access Control (RBAC)

Azure RBAC should enforce least-privilege access.

Recommended roles:

Application

- Key Vault Secrets User

Operations Team

- Key Vault Administrator

Infrastructure Team

- Contributor

Developers

- Reader (production)

This minimizes the blast radius if credentials are compromised.

---

# 5. Service-to-Service Access

Communication between Azure services should use Azure Active Directory authentication whenever possible.

Examples:

Container App

↓

Managed Identity

↓

Key Vault

Container App

↓

Managed Identity

↓

Azure Database for PostgreSQL

This removes the need for long-lived passwords.

All communication should use TLS encryption.

---

# 6. Environment-Specific Configuration

Each environment should maintain separate resources.

Development

- Separate PostgreSQL instance
- Separate Key Vault
- Separate Container App

Testing

- Independent infrastructure

Production

- Isolated infrastructure
- Production secrets
- Production monitoring

Configuration values should be injected through environment variables during deployment rather than being hardcoded.

---

# 7. Network Boundaries

Public Components

- Azure Container App Ingress

Private Components

- Azure Database for PostgreSQL
- Azure Key Vault

Networking should use:

- Azure Virtual Network (VNet)
- Private Endpoints
- Private DNS Zones
- Network Security Groups (NSGs)

Database traffic should never be exposed directly to the internet.

---

# 8. Secure Communication

All traffic should be encrypted using HTTPS and TLS.

Communication path:

Fleet Devices

↓

HTTPS

↓

Azure Container App

↓

Private Network

↓

Azure Database for PostgreSQL

↓

Private Endpoint

↓

Azure Key Vault

Internal Azure services should communicate only over private networking whenever possible.

---

# Production Security Summary

The production security model focuses on:

- Azure Key Vault for secret management
- Managed Identity instead of stored credentials
- Azure RBAC with least-privilege permissions
- Environment isolation
- Private networking for internal services
- TLS encryption for all communication
- No secrets committed to source control or container images

This approach improves security, simplifies secret rotation, and aligns with Azure production best practices.