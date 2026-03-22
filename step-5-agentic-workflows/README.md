# Step 5: Agentic Workflows — Automation

## What We're Building

An automation that fires the AI triage agent automatically when a SEV1 or SEV2 incident is created — no human needs to click anything.

## The Shift

Up to now, the on-call had to:
1. Open the dashboard
2. See the incident
3. Manually click "Trigger AI Triage"

With this automation, the AI starts investigating **the moment the incident is created**. By the time the on-call opens their dashboard, the triage is already done.

## Key Concepts

**Automation vs Self-Service Action:**
- Self-service: triggered by a human clicking a button
- Automation: triggered by an event in the catalog (entity created, updated, etc.)

**Three different variable contexts** (easy to mix up!):

| Context | Variable syntax |
|---------|----------------|
| Self-service action body | `{{ .entity.identifier }}` |
| Automation trigger condition (JQ) | `.diff.after.properties.severity` |
| Automation webhook body | `{{ .event.diff.after.identifier }}` |

## Files

- `auto-triage-automation.json` — the automation config

## How to Apply

Use the Port MCP:
```
upsert_action with the contents of auto-triage-automation.json
```

Or paste directly into Port UI at **https://app.getport.io/settings/automations**
