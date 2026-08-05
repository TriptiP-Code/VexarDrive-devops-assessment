# VexarDrive Fleet Ping Service – Production Readiness Assessment

## Overview

This repository contains my submission for the **VexarDrive DevOps Assessment**.

The objective was to review an inherited Node.js application and prepare it for production by improving its containerization, deployment strategy, security, infrastructure design, and operational readiness.

The assessment focuses on engineering decisions rather than simply making the application run.

---

# Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── deploy.yml
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── network.tf
│   ├── postgres.tf
│   ├── keyvault.tf
│   ├── containerapp.tf
│   ├── monitoring.tf
│   ├── outputs.tf
│   └── README.md
├── Dockerfile
├── docker-compose.yml
├── server.js
├── package.json
├── .dockerignore
├── .gitignore
├── production-review.md
├── database-operations.md
├── secrets-identity-networking.md
├── monitoring-observability.md
├── architecture-diagram.md
├── technical-report.md
└── README.md
```

---

# Improvements Implemented

## Application

- Replaced per-request PostgreSQL connections with a shared connection pool.
- Added `/health` endpoint.
- Added `/ready` endpoint with database connectivity checks.
- Added graceful shutdown handling.
- Improved database error handling.
- Parameterized SQL query for the login endpoint.

---

## Containerization

- Switched from `node:latest` to `node:22-alpine`.
- Reduced Docker image size.
- Added `.dockerignore`.
- Added `.gitignore`.
- Optimized dependency installation using `npm ci`.
- Added Docker health checks.
- Added restart policy.
- Externalized configuration using environment variables.

---

## Infrastructure

Designed Azure infrastructure using Terraform for:

- Azure Container Apps
- Azure Database for PostgreSQL
- Azure Key Vault
- Azure Virtual Network
- Azure Monitor
- Log Analytics Workspace

---

## CI/CD

Designed an improved GitHub Actions pipeline covering:

- Checkout
- Install Dependencies
- Test
- Build
- Containerize
- Push Image
- Deploy
- Verify Deployment

The workflow also documents future production enhancements including security scanning, deployment approvals, rollback strategy, and multi-environment deployments.

---

## Monitoring

Implemented:

- Health endpoint
- Readiness endpoint
- Docker health checks

Proposed production monitoring includes:

- Azure Monitor
- Application Insights
- Log Analytics
- Operational alerts

---

# Running the Application

## Prerequisites

- Docker
- Docker Compose

---

## Clone Repository

```bash
git clone <repository-url>
cd devops-assessment
```

---

## Configure Environment

Create a `.env` file.

Example:

```env
PORT=3000
NODE_ENV=development

DB_HOST=db
DB_PORT=5432
DB_USER=vexaradmin
DB_PASSWORD=your_password
DB_NAME=vexar_fleet

JWT_SECRET=your_secret
```

---

## Start the Application

```bash
docker compose up --build
```

---

## Verify Health

Application:

```
http://localhost:3000/health
```

Readiness:

```
http://localhost:3000/ready
```

---

# Documentation

The following documents are included as part of the assessment:

| Document | Description |
|----------|-------------|
| `production-review.md` | Initial repository assessment and production readiness review |
| `database-operations.md` | Database operations strategy |
| `secrets-identity-networking.md` | Security model and networking design |
| `monitoring-observability.md` | Monitoring and observability strategy |
| `architecture-diagram.md` | Proposed Azure architecture |
| `technical-report.md` | Engineering decisions and implementation summary |

---

# Technology Stack

Application

- Node.js
- Express
- PostgreSQL

Containerization

- Docker
- Docker Compose

Cloud

- Azure Container Apps
- Azure Database for PostgreSQL
- Azure Key Vault
- Azure Monitor

Infrastructure as Code

- Terraform

CI/CD

- GitHub Actions

---

# Future Improvements

Given additional time, I would further enhance the solution by:

- Database migration automation using Flyway or Liquibase
- Running containers as a non-root user
- Structured logging with Pino or Winston
- Automated unit and integration tests
- Container vulnerability scanning (Trivy)
- Blue-Green or Canary deployments
- Azure Application Insights integration
- Automatic secret rotation through Azure Key Vault

---

# Assessment Deliverables

- ✅ Application Review & Production Readiness
- ✅ Containerization
- ✅ Infrastructure as Code (Terraform)
- ✅ CI/CD Pipeline
- ✅ Database Operations
- ✅ Secrets, Identity & Networking
- ✅ Monitoring & Observability
- ✅ Architecture Diagram
- ✅ Technical Report

---

# Author

**Tripti Pandey**

DevOps Engineer | AWS | Docker | Kubernetes | Terraform | Azure | CI/CD