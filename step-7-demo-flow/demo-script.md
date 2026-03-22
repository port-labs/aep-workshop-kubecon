# Demo Script: Full Incident Flow

A step-by-step script for the live demo portion of the workshop.

---

## Setup (Before Demo)

### 1. Verify Sample Data Exists
- [ ] Services: payments-service, checkout-service, inventory-service
- [ ] Environments: production, staging
- [ ] Recent deployment: payments-service v2.3.1 (45 min ago)
- [ ] On-call schedule for payments-service

### 2. Open These Tabs
1. Port On-Call Dashboard
2. Port Incidents list (empty or only resolved)
3. Slack #incidents channel
4. Terminal ready to create incident

### 3. Test the Flow
Run through once privately to ensure everything works.

---

## Demo Script

### PART 1: Set the Scene (2 min)

**Say:**
> "Let's see everything we built in action. Imagine you're on-call for the payments team. It's 2 PM, you're in the middle of something, and suddenly..."

**Do:**
- Show the On-Call Dashboard
- Point out: "My services, recent deployments, no incidents yet"

---

### PART 2: Incident Arrives (2 min)

**Say:**
> "An alert fires. In the real world, this comes from PagerDuty. For the demo, I'll create it manually."

**Do:**
Create the incident via Port MCP or UI:

```
Incident: INC-042
Title: payments-service high latency
Severity: SEV2
Status: triggered
Affected Service: payments-service
Description: P99 latency > 3s, customers reporting slow checkout
```

**Say:**
> "The incident appears in our dashboard. Status is 'triggered' — we haven't looked at it yet."

**Show:**
- Incident in the dashboard
- Note: No triage summary yet

---

### PART 3: AI Triage Runs (3 min)

**Say:**
> "Here's where the magic happens. We set up an automation: when a SEV1 or SEV2 incident is created, the AI triage agent automatically investigates."

**Do:**
- Wait a few seconds for automation to trigger
- Refresh the incident

**Say:**
> "Let's see what the agent found..."

**Show:**
- Open the incident entity
- Scroll to `triage_summary` field
- Read key findings aloud:
  - "Recent deployment 45 minutes ago"
  - "Hypothesis: code_bug"
  - "Recommends rollback"

**Say:**
> "In under a minute, the agent gathered context I would have spent 15 minutes collecting manually. It checked the service, found the deployment, correlated the timing, and formed a hypothesis."

---

### PART 4: Slack Notification (1 min)

**Say:**
> "The team also gets notified in Slack with the triage summary."

**Show:**
- Switch to Slack #incidents
- Show the notification with:
  - Incident details
  - AI hypothesis
  - "View in Port" and "Rollback" buttons

**Say:**
> "Anyone on the team can see this and jump in. The buttons link directly to Port actions."

---

### PART 5: Take Action (3 min)

**Say:**
> "Based on the AI's recommendation, I'm going to rollback. Let's do it."

**Do:**
- Click "Rollback Service" (from Slack or Port)
- Fill in the action form:
  - Environment: production
  - Reason: "AI triage identified v2.3.1 deployment as likely cause"
  - Confirm: checked
- Execute the action

**Say:**
> "The rollback workflow is now running. In a real environment, this would trigger our CD pipeline to redeploy the previous version."

**Show:**
- Action run status
- (If you have a real workflow) Show it executing

---

### PART 6: Resolution (2 min)

**Say:**
> "Once the rollback completes and we verify the fix, we update the incident status."

**Do:**
- Use "Update Incident Status" action
- Set status to "resolved"
- Add root cause: "Retry logic in v2.3.1 caused connection pool exhaustion"

**Show:**
- Incident now shows "resolved"
- Time to resolve calculated automatically

**Say:**
> "The full incident lifecycle is captured. We have:
> - When it started
> - AI triage findings
> - What action we took
> - When it resolved
> - Root cause
> 
> This is your incident postmortem data, captured automatically."

---

### PART 7: The Bigger Picture (2 min)

**Say:**
> "Let's zoom out. What did we just see?"

**Show the flow diagram:**

```
Alert → Incident Created → AI Triage → Slack Notification → Human Reviews → Action Taken → Resolved
         (automatic)       (automatic)    (automatic)        (human)        (human)       (automatic)
```

**Say:**
> "The AI didn't replace the human. It did the tedious context-gathering so the human could focus on the decision. That's the AEP model:
> 
> - **Catalog** gives the agent context
> - **Actions** give the agent hands
> - **MCP** gives the agent external tools
> - **Humans** stay in the loop for decisions
> 
> The result: faster MTTR, less context-switching, better incident data."

---

## Backup Plan

If the live demo fails:

### Option A: Manual Walkthrough
1. Show pre-created incident with triage summary
2. Explain what the automation would have done
3. Still demo the action execution

### Option B: Video Backup
- Have a 3-minute screen recording ready
- "Let me show you a recording of this flow working"

### Option C: Explain and Move On
- "The automation isn't cooperating, but here's what happens..."
- Draw the flow on a whiteboard/slide
- Promise the repo has working configs

---

## Timing

| Section | Duration |
|---------|----------|
| Set the scene | 2 min |
| Incident arrives | 2 min |
| AI triage | 3 min |
| Slack notification | 1 min |
| Take action | 3 min |
| Resolution | 2 min |
| Bigger picture | 2 min |
| **Total** | **15 min** |

Leave 5 minutes buffer for questions during the demo.
