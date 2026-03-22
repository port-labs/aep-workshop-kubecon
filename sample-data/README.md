# Sample Data for Demo

This folder contains sample entities to populate your Port catalog for the workshop demo.

## What's Included

### Services
- `payments-service` — Tier 1, critical path for revenue
- `checkout-service` — Tier 1, customer-facing checkout flow
- `inventory-service` — Tier 2, inventory management
- `notification-service` — Tier 3, email/SMS notifications

### Environments
- `production` — Live customer traffic
- `staging` — Pre-production testing
- `development` — Development environment

### Deployments
- Recent deployments to set up the "bad deploy" scenario
- `payments-service v2.3.1` — The problematic deployment (45 min ago)
- `payments-service v2.3.0` — The stable previous version

### On-Call Schedules
- Current on-call for each service

### Incidents (Optional)
- Sample resolved incidents for history
- The demo incident will be created live

## How to Load

### Option A: Via Cursor + Port MCP
```
"Create the sample services from sample-data"
"Create the sample deployments from sample-data"
```

### Option B: Via Script
```bash
# Set your Port credentials
export PORT_CLIENT_ID="your-client-id"
export PORT_CLIENT_SECRET="your-client-secret"

# Run the loader script
./load-sample-data.sh
```

### Option C: Manual
Copy-paste the JSON into Port's entity creation UI.

## Customization

Before the workshop, update these values:
- Team names to match your Port teams
- User emails to match your Port users
- Timestamps to be relative to demo time
