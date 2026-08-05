# Technical Report

## VexarDrive Fleet Ping Service – Production Readiness Assessment

## 1. Introduction

This assessment evaluates the provided Fleet Ping Service from the perspective of taking ownership of a production application. The objective was not only to make the application functional but to improve its reliability, security, maintainability, and operational readiness using DevOps and cloud engineering best practices.

The repository was initially reviewed to identify production risks before implementing targeted improvements. The work focused on containerization, infrastructure design, CI/CD, database operations, security, monitoring, and operational documentation.

---

# 2. Initial Repository Assessment

During the initial review, several issues were identified that would prevent the application from being considered production ready.

Major observations included:

- Database credentials and secrets exposed in the repository
- Missing `.gitignore` and `.dockerignore` files
- Large Docker build context because unnecessary files were copied into the image
- Docker image built using `node:latest`, resulting in larger and unpredictable images
- No application health or readiness endpoints
- Database connections opened and closed for every request
- No graceful shutdown handling
- No container health checks
- No restart policy
- Basic GitHub Actions workflow without testing, security scanning, or deployment validation
- Missing Infrastructure as Code
- Missing operational documentation

These findings were prioritized based on production risk and operational impact.

---

# 3. Changes Implemented

## Application

- Replaced per-request PostgreSQL connections with a shared connection pool.
- Added application health endpoint (`/health`).
- Added readiness endpoint (`/ready`) with database connectivity verification.
- Added graceful shutdown handling for HTTP server and PostgreSQL connection pool.
- Improved database error handling.
- Replaced string-built SQL query in the login endpoint with a parameterized query to reduce SQL injection risk.

---

## Containerization

- Switched from `node:latest` to `node:22-alpine`.
- Reduced image size using a lightweight Alpine base image.
- Optimized dependency installation with `npm ci --omit=dev`.
- Added `.dockerignore`.
- Added `.gitignore`.
- Configured Docker Compose health checks.
- Added container restart policy.
- Externalized configuration using environment variables.

---

## Infrastructure as Code

Designed Azure infrastructure using Terraform including:

- Azure Resource Group
- Azure Container Apps
- Azure Database for PostgreSQL Flexible Server
- Azure Key Vault
- Azure Virtual Network
- Azure Monitor
- Log Analytics Workspace

The Terraform configuration was organized into separate modules/files to improve readability and future maintenance.

---

## CI/CD

Designed an improved GitHub Actions workflow that demonstrates a production deployment pipeline.

Pipeline stages include:

- Source checkout
- Dependency installation
- Application testing
- Docker image build
- Container image push
- Deployment
- Deployment verification

The report also documents future enhancements including approval gates, rollback strategy, environment promotion, and security scanning.

---

## Monitoring

Implemented:

- Health endpoint
- Readiness endpoint
- Docker health checks

Defined production monitoring using:

- Azure Monitor
- Application Insights
- Log Analytics
- Operational alerts

---

## Documentation

Prepared production documentation covering:

- Production readiness review
- Database operations
- Secrets and identity
- Monitoring strategy
- Architecture
- Terraform deployment
- Technical report

---

# 4. Architecture Decisions

Azure Container Apps were selected instead of Azure Kubernetes Service (AKS).

Reasons include:

- Lower operational overhead
- Built-in autoscaling
- Suitable for small to medium microservices
- Lower infrastructure cost
- Simpler deployment model

Terraform was selected for Infrastructure as Code because it is cloud-agnostic, widely adopted, and enables repeatable deployments.

---

# 5. Security Approach

Security improvements focused on eliminating unnecessary risk.

Key recommendations include:

- Store secrets in Azure Key Vault
- Use Managed Identity
- Apply least-privilege RBAC
- Separate environments
- Avoid committing secrets to Git
- Use HTTPS/TLS for all communication
- Restrict database access to private networking

---

# 6. Database Strategy

Database improvements included:

- PostgreSQL connection pooling
- Production backup strategy
- Point-in-Time Recovery
- Least-privilege database accounts
- Migration strategy using Flyway or Liquibase
- Future scaling with read replicas and partitioning

---

# 7. Deployment Strategy

The recommended deployment workflow is:

Developer

↓

GitHub Repository

↓

GitHub Actions

↓

Build & Test

↓

Container Image

↓

Azure Container Registry

↓

Azure Container Apps

↓

Health Verification

Future production deployments should include:

- Multiple environments
- Manual production approval
- Blue-Green or Canary deployments
- Automated rollback

---

# 8. Monitoring Strategy

Production monitoring should include:

Metrics

- CPU
- Memory
- Request rate
- Error rate
- Database connections

Logs

- Application logs
- Container logs
- Database logs
- Azure Activity Logs

Alerts

- High error rate
- Database unavailable
- High CPU
- High memory
- Container restart loops

---

# 9. Assumptions and Constraints

The assessment assumes:

- Azure infrastructure is not required to be deployed.
- Infrastructure is demonstrated through Terraform.
- Production architecture is designed according to Azure best practices.
- Database schema was outside the scope of the supplied repository.

---

# 10. Known Limitations

The following items were intentionally not implemented due to assessment scope:

- Live Azure deployment
- Production Key Vault integration
- Managed Identity authentication
- Automated database migrations
- Production monitoring dashboards
- End-to-end automated testing

These would require Azure resources or additional application components beyond the provided repository.

---

# 11. Cost Considerations

Azure Container Apps were selected to minimize infrastructure costs while supporting autoscaling.

Additional cost optimizations include:

- Autoscaling based on demand
- Consumption-based compute
- Automatic PostgreSQL backups
- Log retention policies
- Environment separation

---

# 12. Scalability Considerations

As fleet size increases, the architecture can evolve by:

- Scaling Azure Container Apps horizontally
- Increasing PostgreSQL compute
- Adding read replicas
- Partitioning telemetry tables
- Introducing Azure Event Hub or Service Bus for high-volume ingestion
- Archiving historical telemetry data

These improvements allow the platform to support significantly larger numbers of connected fleet vehicles.

---

# 13. Future Improvements

With additional engineering time, the following enhancements would be prioritized:

- Add database initialization and migration scripts
- Run containers as a non-root user
- Implement structured logging using Pino or Winston
- Add automated unit and integration tests
- Add vulnerability scanning (Trivy)
- Add dependency scanning
- Implement Blue-Green deployments
- Configure Azure Monitor dashboards
- Integrate Application Insights telemetry
- Configure automatic secret rotation through Azure Key Vault

---

# 14. Conclusion

The assessment transformed the provided repository from a development-oriented project into a production-oriented design. The implemented improvements enhance reliability, security, maintainability, and operational readiness while demonstrating modern DevOps practices.

Although a live Azure deployment was outside the assessment scope, the proposed architecture, Infrastructure as Code, CI/CD workflow, security model, and operational documentation provide a solid foundation for deploying and operating the Fleet Ping Service in a production Azure environment.