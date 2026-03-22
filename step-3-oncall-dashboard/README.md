# Step 3: On-Call Dashboard — One Pane of Glass

## What We're Building

A single dashboard where the on-call engineer has everything they need during an incident — no more jumping between pages.

## The Problem

We have visibility (catalog) and actions. But during an incident, the on-call is still clicking around:
- Incidents page → Deployments page → Services page → Self-service hub

One dashboard fixes this.

## Dashboard: "On-Call Dashboard"

Create at: **https://app.getport.io** → `+ New` → `New page` → `Dashboard`

### Widgets

| Widget | Type | Blueprint | Filter |
|--------|------|-----------|--------|
| Active Incidents | Table | Incident | `status` is not `resolved` |
| Recent Deployments | Table | Deployment | `deployed_at` in last 24 hours |
| My Services | Table | Service | — |
| Quick Actions | Action Card | — | Acknowledge, Update Status, Page On-Call, Rollback, Scale |
| On-Call Triage Agent | AI Agent | — | Select `oncall_triage_agent` |

### Widget Order (recommended)

Place the AI agent widget prominently — it's the main interaction point during an incident. Suggested layout:
- Top row: Active Incidents (wide) + Quick Actions
- Middle row: Recent Deployments (wide)
- Bottom row: My Services + AI Agent chat

## Note on the AI Agent Widget

The AI agent widget is added in Step 4 after the agent is created. Come back and add it then.

The conversation starters appear directly in the widget — on-call engineers can click them instead of typing from scratch.
