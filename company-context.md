# Company Context: Matar's Iced Americano

This document describes the fictional company we're building for in this workshop. Use this context when designing the data model.

---

## About Matar's Iced Americano

**Industry:** Coffee delivery platform (think DoorDash meets Blue Bottle)
**Size:** ~200 engineers across 15 teams
**Stack:** Kubernetes on AWS, mix of Go and TypeScript services
**Pain point:** On-call is painful — too many tools, too much context-switching, slow incident response

---

## How They Talk About Their Software

| They say | Not |
|----------|-----|
| "Services" | "Microservices" or "Applications" |
| "Teams" | "Squads" or "Pods" |
| "Environments" | "Stages" or "Tiers" |
| "Deployments" | "Releases" |
| "Incidents" | "Alerts" or "Pages" |

---

## Organizational Structure

### Teams
- **Payments Team** — owns checkout and payment processing
- **Platform Team** — owns infrastructure, API gateway, shared services
- **Menu Team** — owns product catalog and search
- **Fulfillment Team** — owns orders, inventory, delivery routing

### Service Tiers
| Tier | Definition | SLA | Examples |
|------|------------|-----|----------|
| **Tier 1** | Revenue-critical, customer-facing | 99.9% uptime, 15-min response | payments-service, checkout-service, api-gateway |
| **Tier 2** | Important but not revenue-blocking | 99.5% uptime, 1-hour response | inventory-service, search-service |
| **Tier 3** | Internal tools, async processes | Best effort | notification-service, analytics-pipeline |

---

## Key Services (for demo)

| Service | Team | Tier | Description |
|---------|------|------|-------------|
| `payments-service` | Payments | 1 | Processes credit cards, digital wallets, invoicing |
| `checkout-service` | Payments | 1 | Orchestrates cart → payment → order flow |
| `api-gateway` | Platform | 1 | Edge service: auth, rate limiting, routing |
| `inventory-service` | Fulfillment | 2 | Stock levels, warehouse integration |
| `notification-service` | Platform | 3 | Email, SMS, push notifications |

---

## Environments

| Environment | Purpose | Who deploys | Approval needed |
|-------------|---------|-------------|-----------------|
| `development` | Integration testing | Anyone | No |
| `staging` | Pre-prod validation | Anyone | No |
| `production` | Live traffic | CI/CD | Yes (for Tier 1) |

---

## Deployment Flow

```
PR merged → CI builds → Deploy to staging → Tests pass → Deploy to production
                                                              ↓
                                                    (Tier 1: requires approval)
```

- Deployments are tracked by version (semver or commit SHA)
- Each deployment records: who deployed, when, what changed
- Rollback = deploy previous version

---

## Incident Management

### Severity Levels
| Severity | Definition | Response time | Example |
|----------|------------|---------------|---------|
| **SEV1** | Revenue impact, all customers affected | 15 min | Payments down |
| **SEV2** | Degraded experience, partial impact | 30 min | High latency |
| **SEV3** | Minor issue, workaround exists | 4 hours | UI bug |
| **SEV4** | Cosmetic, no user impact | Next sprint | Typo in logs |

### Incident Lifecycle
```
triggered → acknowledged → investigating → identified → monitoring → resolved
```

### On-Call Structure
- Each team has a **primary** and **secondary** on-call
- Rotation: weekly
- Escalation: primary → secondary → team lead → engineering manager
- Tool: PagerDuty (but want to reduce dependency on it)

---

## Current Pain Points (Why We're Building This)

1. **Too many tools during incidents**
   - PagerDuty for alerts
   - Datadog for metrics/logs
   - GitHub for recent commits
   - Slack for coordination
   - Confluence for runbooks
   - *"I spend 15 minutes just gathering context before I can even think about the problem"*

2. **No single source of truth**
   - Service ownership lives in a spreadsheet
   - Deployment history is scattered across CI tools
   - On-call schedules are in PagerDuty but not connected to services

3. **Tribal knowledge**
   - Senior engineers resolve incidents fast because they know the system
   - Junior engineers struggle — they don't know what to check first
   - *"We need to capture what experts do and make it available to everyone"*

4. **Slow MTTR**
   - Average time to acknowledge: 8 minutes
   - Average time to resolve: 45 minutes
   - Goal: Cut both in half

---

## What Success Looks Like

After this workshop, Matar's Iced Americano will have:

1. **Single pane of glass** — On-call dashboard with services, incidents, deployments
2. **AI-assisted triage** — Agent that gathers context in seconds, not minutes
3. **Self-service actions** — Rollback, scale, page without leaving Port
4. **Audit trail** — Every incident, every action, every AI recommendation logged

---

## Data Model Requirements

Based on this context, the catalog needs:

### Blueprints
- **Service** — already exists, may need enrichment
- **Environment** — already exists
- **Incident** — NEW: track production issues
- **Deployment** — NEW: what's running where
- **On-Call Schedule** — NEW: who's responsible

### Key Relations
```
incident → service (affected service)
incident → deployment (potential cause)
deployment → service
deployment → environment
oncall_schedule → service
oncall_schedule → user
```

### Key Properties

**Incident:**
- severity (SEV1-4)
- status (triggered → resolved)
- timestamps (triggered, acknowledged, resolved)
- AI triage fields (hypothesis, summary)

**Deployment:**
- version
- status (pending, succeeded, failed, rolled_back)
- commit info (SHA, message, PR link)
- who deployed, when

**On-Call Schedule:**
- type (primary, secondary, escalation)
- shift times
- contact info (Slack handle, phone)

---

## Demo Scenario

**The incident we'll trigger:**

> payments-service is experiencing high latency. P99 jumped from 120ms to 3.2s. 
> Customers are reporting slow checkout. 
> 
> Root cause: A deployment 45 minutes ago added retry logic that's causing 
> connection pool exhaustion under load.
> 
> Resolution: Rollback to previous version.

This scenario demonstrates:
- AI correlating incident timing with deployment
- Agent recommending rollback based on evidence
- Human approving and executing the action
- Full audit trail captured
