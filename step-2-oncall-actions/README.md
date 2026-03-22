# Step 2: Self-Service Actions

## What We're Building

6 actions that let on-call engineers act without leaving the portal — and that the AI agent will use to write back its findings.

## The Problem

The on-call can see everything in the catalog. But to act, they still have to:
- SSH into a bastion host to run a rollback script
- Open the cloud console to scale replicas
- Go to PagerDuty to page someone

Context switching kills incident response time.

## Actions

| File | Action | Blueprint | Backend | Purpose |
|------|--------|-----------|---------|---------|
| `acknowledge-incident.action.json` | Acknowledge Incident | Incident | UPSERT_ENTITY | Mark you're on it (only shows when status = triggered) |
| `update-incident-status.action.json` | Update Incident Status | Incident | UPSERT_ENTITY | Track progress through the lifecycle |
| `page-oncall.action.json` | Page On-Call | Incident | UPSERT_ENTITY | Escalate to primary/secondary/manager |
| `update-incident-triage.action.json` | Update Incident Triage | Incident | UPSERT_ENTITY | **Used by AI agent** to write triage_summary + hypothesis |
| `trigger-ai-triage.action.json` | Trigger AI Triage | Incident | WEBHOOK | Manually invoke the AI agent on demand |
| `rollback-service.action.json` | Rollback Service | Service | UPSERT_ENTITY | Revert to a previous version |
| `scale-service.action.json` | Scale Service | Service | UPSERT_ENTITY | Increase/decrease replicas |

## Key Concepts

**UPSERT_ENTITY backend** — updates the catalog directly. No external webhooks needed for the workshop. In production, wire these to GitHub Actions, Terraform, etc.

**`update_incident_triage`** — this action is called by the AI agent, not humans. It's how the agent writes its findings back to the incident entity. The agent uses the same action system as humans — same guardrails, same audit trail.

**`trigger_ai_triage`** — uses a WEBHOOK backend calling Port's agent API. Key settings:
- `synchronized: true` — Port waits for the agent to finish
- `agent: false` — Port handles auth internally, no token needed in headers

## The Bridge to Step 5

`trigger_ai_triage` is the manual version of what the automation does in Step 5. The on-call can always re-run triage on demand, even after the automation has already fired.
