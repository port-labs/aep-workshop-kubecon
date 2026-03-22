# Step 4: AI Triage Agent — The Copilot

## What We're Building

An AI agent that investigates incidents by querying the catalog, forms a hypothesis, and writes its findings back to the incident entity.

## The Shift: IDP → AEP

Everything we built so far was foundation:
- The **catalog** gives the AI context (what it can see)
- The **actions** give the AI hands (what it can do)
- The **dashboard** is where the human and AI collaborate

Now we add the brain.

## Key Design: Write-Back via Action

The agent can't update entities directly. It calls the `update_incident_triage` self-service action to write:
- `triage_summary` — full markdown analysis with evidence
- `hypothesis` — root cause category

This means the agent uses the same action system as humans. Same guardrails, same audit trail.

**Create `update_incident_triage` BEFORE the agent** (it's in `step-2-oncall-actions/`).

## Agent Configuration

**File:** `oncall-triage-agent.json`

Key fields:
- `tools` — regex patterns for catalog tools + `run_update_incident_triage` (the write-back action)
- `execution_mode: "Automatic"` — agent runs without requiring approval
- `conversation_starters` — pre-built prompts for the dashboard widget

## Conversation Starters

Designed for use from the On-Call Dashboard widget — click instead of type:

1. "Investigate this incident - what service is affected, what changed recently, and what should I do?"
2. "Show me all deployments from the last 24 hours and flag anything suspicious"
3. "Who is on-call right now for the affected service?"
4. "Should I rollback? What version and why?"
5. "What's the blast radius - what other services might be affected?"
6. "Help me write a status update for this incident"

## Investigation Framework (in the prompt)

The agent follows 6 steps:
1. Establish Context (service tier, severity)
2. Correlate with Changes (deployments in last 48h)
3. Identify Blast Radius (dependent services)
4. Find the Right People (on-call, who deployed)
5. Form a Hypothesis (code_bug / infrastructure / external_dependency / configuration / capacity)
6. Write Findings Back (calls `update_incident_triage`)

## How to Apply

Create via Port MCP:
```
upsert_entity on _ai_agent blueprint
with contents of oncall-triage-agent.json
```

Then add the agent as a widget on the On-Call Dashboard.
