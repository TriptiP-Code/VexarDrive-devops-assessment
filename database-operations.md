# Database Operations

## Overview

The application uses Azure Database for PostgreSQL as the primary relational database. The production deployment should prioritize reliability, availability, security, and scalability while maintaining efficient database connectivity from the application.

---

# 1. Backup and Recovery

## Approach

Use Azure Database for PostgreSQL Flexible Server with automatic backups enabled.

### Backup Strategy

- Automatic daily backups
- Backup retention: 14–35 days (depending on business requirements)
- Geo-redundant backups for disaster recovery
- Regular backup validation through restore testing

### Why

Automatic backups reduce operational overhead while ensuring recovery from accidental deletion, corruption, or infrastructure failures.

---

# 2. Point-in-Time Recovery (PITR)

Enable Point-in-Time Recovery (PITR).

This allows restoration of the database to any specific point within the backup retention period.

Example use cases:

- Accidental DELETE statement
- Failed deployment
- Data corruption
- Human error

Recovery Objective:

- Recovery Point Objective (RPO): typically under 5 minutes
- Recovery Time Objective (RTO): depends on database size

---

# 3. Database Connection Management

## Current Issue

The inherited application opened and closed a PostgreSQL connection for every request.

Problems:

- High latency
- Excessive connection creation
- Database resource exhaustion
- Poor scalability

## Improvement

The application was updated to use a shared PostgreSQL connection pool.

Benefits:

- Reuses existing connections
- Lower latency
- Better throughput
- Reduced CPU usage on PostgreSQL
- Handles concurrent traffic efficiently

---

# 4. Bursty Application Traffic

Fleet devices may send thousands of GPS pings simultaneously.

To handle traffic spikes:

- Use PostgreSQL connection pooling
- Configure maximum pool size
- Scale Azure Container Apps horizontally
- Enable autoscaling based on CPU and HTTP requests
- Use retry logic for transient failures
- Introduce message queues (Azure Service Bus/Event Hub) for very high ingestion rates

This prevents overwhelming the database during peak load.

---

# 5. Access Control

Database access should follow the principle of least privilege.

Application account:

Permissions:

- SELECT
- INSERT
- UPDATE (only where required)

Avoid:

- SUPERUSER
- CREATEDB
- CREATEROLE

Separate administrator accounts should be used for operational tasks.

---

# 6. Least-Privilege Permissions

Create dedicated database users for each environment.

Example:

Development

- app-dev

Testing

- app-test

Production

- app-prod

Each account should have access only to its own database.

Credentials should never be stored inside source code.

They should be retrieved securely from Azure Key Vault using Managed Identity.

---

# 7. Schema Changes and Migrations

Database schema changes should never be performed manually.

Recommended approach:

- Flyway
or
- Liquibase

Migration workflow:

Developer
↓

GitHub

↓

CI Pipeline

↓

Run Database Migration

↓

Deploy Application

Benefits:

- Version-controlled schema
- Repeatable deployments
- Rollback support
- Auditable database changes

---

# 8. Scaling Strategy

As fleet size increases:

Initial Stage

- Single Azure PostgreSQL Flexible Server

Medium Scale

- Increase compute and storage
- Tune indexes
- Optimize queries
- Connection pooling

Large Scale

- Read replicas
- Partition fleet_pings table by date
- Archive historical telemetry
- Separate analytical workloads from transactional workloads

Very Large Scale

Move high-volume telemetry ingestion through:

Fleet Devices

↓

Azure Event Hub

↓

Consumers

↓

PostgreSQL

This prevents direct database overload.

---

# Production Summary

Production database operations should focus on:

- Automated backups
- Point-in-Time Recovery
- Connection pooling
- Least-privilege access
- Secure secret management
- Version-controlled migrations
- Horizontal application scaling
- Future-ready database architecture