# Step 6: Live Demo — The Full Flow

**Goal:** Show everything working together. Trigger an incident, watch the AI triage, see the recommendation, take action.

## The Demo Scenario

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         DEMO FLOW                                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  1. TRIGGER                                                             │
│     └──▶ PagerDuty alert fires (or manual incident creation)           │
│                                                                         │
│  2. AUTOMATION                                                          │
│     └──▶ Port automation detects new incident                          │
│     └──▶ Triggers AI triage agent                                      │
│                                                                         │
│  3. TRIAGE                                                              │
│     └──▶ Agent queries catalog (service, deployments, ownership)       │
│     └──▶ Agent queries MCP servers (logs, metrics)                     │
│     └──▶ Agent forms hypothesis and recommendation                     │
│                                                                         │
│  4. NOTIFICATION                                                        │
│     └──▶ Triage summary posted to Slack                                │
│     └──▶ Incident entity updated with AI findings                      │
│                                                                         │
│  5. ACTION                                                              │
│     └──▶ On-call reviews recommendation                                │
│     └──▶ Clicks "Rollback" (or other action)                           │
│     └──▶ Workflow executes, incident resolves                          │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## What We'll Demo

### Part 1: The Incident Arrives
- Create an incident manually (or show PagerDuty webhook)
- Watch it appear in the On-Call Dashboard
- Note: Status is "triggered", no triage yet

### Part 2: AI Triage Kicks In
- Automation fires on incident creation
- Agent runs investigation
- Incident entity updated with:
  - `triage_summary` — AI's analysis
  - `hypothesis` — code_bug, infrastructure, etc.

### Part 3: On-Call Responds
- Open the incident in Port
- Read the AI triage summary
- See the recommended action
- Click "Rollback" action
- Watch the workflow execute

### Part 4: Resolution
- Incident status → "resolved"
- Metrics show MTTR improvement
- Full audit trail preserved

## Files in This Folder

- `auto-triage-automation.json` — Automation that triggers AI triage on incident creation
- `incident-webhook.json` — Webhook config for PagerDuty integration
- `slack-notification-automation.json` — Post triage results to Slack
- `demo-script.md` — Step-by-step demo script

## The Automation: Auto-Triage

When an incident is created, automatically run the triage agent:

```json
{
  "trigger": {
    "type": "automation",
    "event": {
      "type": "ENTITY_CREATED",
      "blueprintIdentifier": "incident"
    }
  },
  "invocationMethod": {
    "type": "WEBHOOK",
    "url": "https://api.getport.io/v1/agents/oncall_triage_agent/invoke",
    "body": {
      "prompt": "Investigate incident {{.entity.identifier}}: {{.entity.title}}. Check the affected service, recent deployments, and form a hypothesis. Update the incident with your findings."
    }
  }
}
```

## Demo Tips

### Before the Demo
1. Create sample data (services, deployments, on-call schedules)
2. Test the automation flow end-to-end
3. Have the dashboard open and ready
4. Pre-stage a "bad deployment" that will be the root cause

### During the Demo
1. **Narrate what's happening** — "Now the automation is triggering..."
2. **Show the data** — Open the incident, show the triage summary
3. **Highlight the value** — "Without AI, this investigation takes 15 minutes"
4. **Take the action** — Don't just talk about rollback, do it

### If Something Goes Wrong
- Have a pre-recorded backup video
- Manual fallback: Create incident, manually invoke agent
- Explain what *should* happen if the live demo fails

## Measuring Success

After the demo, you can show these metrics:

| Metric | Before AEP | After AEP |
|--------|------------|-----------|
| Time to first hypothesis | 15-30 min | < 1 min |
| Context switches during triage | 5-7 tools | 1 dashboard |
| Time to rollback decision | 10-20 min | 2-5 min |

---

**Wrap-up:** Return to main README for Q&A and repo link.
