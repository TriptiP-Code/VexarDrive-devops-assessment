# Monitoring & Observability

## Overview

Reliable production systems require continuous monitoring to detect failures, measure performance, and simplify troubleshooting. The Fleet Ping Service should expose health information, produce structured logs, and integrate with Azure Monitor and Application Insights.

---

# 1. Health Endpoint

## Implemented

The application exposes a health endpoint:

GET /health

Example response:

```json
{
  "status": "UP",
  "service": "Fleet Ping Service",
  "timestamp": "2026-08-05T14:20:30Z"
}
```

Purpose:

- Verify the application is running
- Used by load balancers
- Used by container health checks
- Detect application crashes
```

---

# 2. Readiness Endpoint

## Implemented

The application exposes a readiness endpoint:

GET /ready

The endpoint performs a simple database query:

```sql
SELECT 1;
```

If the database is reachable:

```json
{
  "status": "READY",
  "database": "Connected"
}
```

Otherwise:

```json
{
  "status": "NOT_READY",
  "database": "Unavailable"
}
```

Purpose:

- Prevent traffic before startup completes
- Detect database connectivity failures
- Used by Azure Container Apps readiness probes

---

# 3. Structured Application Logging

## Current State

The inherited application used simple console logging.

Example:

```javascript
console.log(err);
```

## Recommended Improvement

Use structured JSON logging (e.g., Pino or Winston).

Example log:

```json
{
  "level": "error",
  "service": "fleet-ping-service",
  "endpoint": "/api/fleet/ping",
  "message": "Database connection failed",
  "timestamp": "2026-08-05T14:25:12Z"
}
```

Benefits:

- Easier searching
- Better dashboards
- Correlation across services
- Improved incident investigation

---

# 4. Metrics

Key production metrics include:

Application Metrics

- Request rate
- Response time
- Error rate
- Active connections
- Restart count

Database Metrics

- Active connections
- Query latency
- CPU utilization
- Storage utilization
- Deadlocks

Infrastructure Metrics

- CPU usage
- Memory usage
- Container restarts
- Disk utilization
- Network traffic

---

# 5. Logs

Important logs include:

Application Logs

- API requests
- Authentication failures
- Database errors
- Startup and shutdown events

Container Logs

- Container crashes
- Health check failures

Database Logs

- Slow queries
- Connection failures
- Authentication failures

Azure Activity Logs

- Resource changes
- RBAC changes
- Deployment history

---

# 6. Alerts

## High Error Rate

Monitor:

HTTP 5xx responses

Trigger:

More than 5% errors over 5 minutes

Reason:

May indicate application or database failure.

---

## Database Unavailable

Monitor:

Readiness endpoint

Trigger:

Health check fails continuously

Reason:

Application cannot process requests.

---

## High CPU Usage

Monitor:

Container CPU

Trigger:

Above 80% for 10 minutes

Reason:

May require autoscaling.

---

## High Memory Usage

Monitor:

Container memory

Trigger:

Above 85%

Reason:

Potential memory leak or insufficient resources.

---

## Container Restart Loop

Monitor:

Container restart count

Trigger:

More than three restarts within ten minutes

Reason:

Application instability.

---

## PostgreSQL Connection Count

Monitor:

Database active connections

Trigger:

Approaching configured limit

Reason:

Connection exhaustion can prevent new requests.

---

# 7. Azure Monitoring Services

Recommended Azure services:

- Azure Monitor
- Azure Application Insights
- Log Analytics Workspace
- Azure Alerts
- Azure Dashboard

These provide centralized monitoring, querying, dashboards, and alerting.

---

# Production Monitoring Summary

The implemented solution provides:

- Health endpoint
- Readiness endpoint
- Graceful shutdown
- Docker health checks

For production, Azure Monitor and Application Insights should be used to collect metrics, logs, and alerts. Structured logging, proactive alerting, and centralized dashboards enable rapid detection and resolution of operational issues.