# AEP Workshop Builder

Interactive workshop guide for building engineering workflows for on-call — from zero visibility to AI-powered incident response.

## When to Use

Activate this skill when someone:
- Asks to "start the workshop" or "begin the AEP workshop"
- Wants to build on-call workflows in Port
- Says "let's do the workshop"

## The Journey

This workshop takes you through a gradual evolution:

```
No visibility  →  Catalog  →  Self-Service  →  Dashboard  →  AI Agents  →  Agentic Workflows  →  MCP Servers
   (chaos)        (see)        (act)           (focus)      (investigate)      (automate)          (go deeper)
```

Each step builds on the previous. No magic — just good foundations.

## Workshop Pattern

For each step, we follow this pattern:
1. **Learn** — Create the first one manually in the UI (understand what we're building)
2. **Scale** — Use the MCP to create the rest (see how automation works)

This way participants understand both the concepts AND how to automate them.

## JSON Snippets for Manual Steps

**IMPORTANT:** When guiding manual creation steps, ALWAYS provide a JSON snippet that the user can copy-paste into Port's JSON editor. This makes the workshop faster and reduces errors.

Format for providing JSON:
> "Here's the JSON you can copy-paste into Port's JSON editor:
> ```json
> { ... }
> ```
> Or follow the UI steps below if you prefer clicking through the form."

---

## Behavior

When activated, be friendly and guide them through the journey. Start with:

> "Welcome to Port's AEP Workshop!
>
> Today we're building engineering workflows for on-call — step by step.
>
> We'll start with **nothing** — no visibility, no self-service, no AI. Just chaos.
>
> Then we'll gradually build:
> 1. **Visibility** — A catalog so you can see your services, deployments, and incidents
> 2. **Self-Service** — Actions so on-call engineers can actually DO something
> 3. **A Dashboard** — One place to see it all during an incident
> 4. **AI Agents** — A copilot that can investigate and recommend
> 5. **Agentic Workflows** — Automation that triggers the AI when incidents happen
> 6. **MCP Servers** — External tools so the agent can go beyond the catalog into logs, metrics, and code
>
> For each step, we'll create the first one manually so you understand it, then I'll use the MCP to fill in the rest.
>
> By the end, you'll have a complete on-call experience — and you'll understand exactly how it works. No black boxes.
>
> Ready to get started?"

---

## Step 0: Prerequisites

### 0.1 Sign Up to Port

Ask:
> "First, let's make sure you have a Port account.
>
> **Sign up for free:** https://app.getport.io/signup
>
> Let me know when you're logged in!"

### 0.2 Verify Port MCP Connection

Once they confirm, verify the MCP is connected:

```
CallMcpTool: server="user-port-eu", toolName="list_blueprints"
```

**If it fails:**
> "I can't connect to your Port account yet. Let's set up the Port MCP connection first — you'll need to add your Port credentials to the MCP configuration."

**If it succeeds:**
> "Connected! I can see your Port account. Let's build."

---

## Step 1: Visibility — The Catalog

**Reference:** `step-1-catalog-foundation/README.md`

### The Problem

Say:
> "**Step 1: Visibility**
>
> Right now, when an incident happens, the on-call engineer has to:
> - Check Slack to figure out which service is affected
> - SSH into servers or check dashboards to see what's deployed
> - Dig through PagerDuty to find who else is on-call
> - Manually correlate 'did someone deploy recently?'
>
> That's chaos. Let's fix it by building a catalog — a single source of truth."

### What We're Building

> "We're creating 7 blueprints — the data model that represents your engineering world:
>
> | Blueprint | Why it matters for on-call |
> |-----------|---------------------------|
> | Environment | Know if it's prod or staging |
> | Repository | Link code to services |
> | Service | The thing that's on fire |
> | Pull Request | What code changed recently |
> | Deployment | When and what was deployed |
> | Incident | Track the fire |
> | On-Call Schedule | Who to call |
>
> Let's create the first one together manually, then I'll create the rest."

### 1.1 Create First Blueprint Manually (Service)

Guide them through UI creation, providing JSON for copy-paste:
> "Let's create the **Service** blueprint. Here's the JSON you can copy-paste:
>
> 1. Go to **https://app.getport.io/settings/data-model**
> 2. Click **'+ Blueprint'** → **'Edit JSON'** (or use the form)
> 3. Paste this JSON:
>
> ```json
> {
>   "identifier": "service",
>   "title": "Service",
>   "icon": "Microservice",
>   "schema": {
>     "properties": {
>       "tier": {
>         "title": "Tier",
>         "type": "string",
>         "enum": ["Tier 1 - Critical", "Tier 2 - Important", "Tier 3 - Standard"],
>         "enumColors": {
>           "Tier 1 - Critical": "red",
>           "Tier 2 - Important": "orange",
>           "Tier 3 - Standard": "green"
>         }
>       },
>       "lifecycle": {
>         "title": "Lifecycle",
>         "type": "string",
>         "enum": ["production", "experimental", "deprecated"],
>         "enumColors": {
>           "production": "green",
>           "experimental": "orange",
>           "deprecated": "red"
>         }
>       },
>       "description": {
>         "title": "Description",
>         "type": "string"
>       },
>       "slack_channel": {
>         "title": "Slack Channel",
>         "type": "string"
>       }
>     }
>   },
>   "relations": {},
>   "calculationProperties": {},
>   "aggregationProperties": {},
>   "mirrorProperties": {}
> }
> ```
>
> 4. Click **Save**
>
> Let me know when you're done (or say 'create it for me')!"

When they confirm:
> "Great! You just created your first blueprint. 
>
> Notice how you defined the **properties** — these are the fields that every service will have.
>
> Now let me create the remaining 6 blueprints using the MCP. Watch how fast this goes..."

### 1.2 Create Remaining Blueprints via MCP

Create blueprints **in this order** (dependencies matter):

1. `environment` — no dependencies
2. `repository` — no dependencies
3. Update `service` to add relation to repository
4. `pull_request` — relates to repository
5. `deployment` — relates to service + environment
6. `incident` — relates to service + deployment
7. `oncall_schedule` — relates to service

Use `CallMcpTool` with `toolName="upsert_blueprint"` for each.

After each:
> "✓ Created **[Blueprint Name]**"

When all done:
> "All 7 blueprints created!
>
> **See your data model:** https://app.getport.io/settings/data-model
>
> Notice how the blueprints connect to each other — deployments link to services, incidents link to deployments. This is how the AI will understand relationships later.
>
> Now let's add some data. Same pattern — you create one manually, I'll fill in the rest."

### 1.3 Create First Entity Manually (Service)

Guide them with JSON for copy-paste:
> "Let's create a service entity. Here's the JSON you can copy-paste:
>
> 1. Go to **https://app.getport.io/services** (or click on the Service blueprint)
> 2. Click **'+ Service'** → **'Edit JSON'** (or use the form)
> 3. Paste this JSON:
>
> ```json
> {
>   "identifier": "payments-service",
>   "title": "Payments Service",
>   "properties": {
>     "tier": "Tier 1 - Critical",
>     "lifecycle": "production",
>     "description": "Handles all payment processing",
>     "slack_channel": "#payments-team"
>   },
>   "relations": {}
> }
> ```
>
> 4. Click **Save**
>
> Let me know when you're done (or say 'create it for me')!"

When they confirm:
> "You just created your first entity!
>
> Now let me populate the rest of the catalog. I'll create about 50 entities across all blueprints..."

### 1.4 Create Remaining Entities via MCP

**IMPORTANT:** Create 5-8 entities for EACH blueprint.

Use `CallMcpTool` with `toolName="upsert_entity"` for each entity.

**Order matters** — create entities in this sequence (parents before children):

**1. Environments (6 entities):**
- production, staging, development, qa, load-test, dr

**2. Repositories (8 entities):**
- payments-service-repo, checkout-service-repo, inventory-service-repo, api-gateway-repo, notification-service-repo, order-service-repo, user-service-repo, analytics-service-repo

**3. Services (7 more, since they created payments-service):**
- checkout-service, inventory-service, api-gateway, notification-service, order-service, user-service, analytics-service

**4. Pull Requests (8 entities):**
- Mix of open, merged, closed — include PR #847 for payments retry logic

**5. Deployments (10 entities):**
- Include `deploy-payments-v2.3.1-prod` deployed TODAY — the problematic one
- Include `deploy-payments-v2.3.0-prod` from 2 days ago — stable rollback target

**6. On-Call Schedules (8 entities):**
- Primary and secondary for critical services

**7. Incidents (6-8 entities):**
- Mix of statuses to make the dashboard interesting:
  - 1-2 `triggered` (active incidents for demo)
  - 1-2 `investigating` or `acknowledged` (in-progress)
  - 3-4 `resolved` (historical data for AI context)
- Include incidents for different services and severities
- Include root causes for resolved incidents

After creating all entities, confirm:
> "Sample data loaded!
>
> | Blueprint | Count |
> |-----------|-------|
> | Environments | 6 |
> | Repositories | 8 |
> | Services | 8 |
> | Pull Requests | 8 |
> | Deployments | 10 |
> | On-Call Schedules | 8 |
> | Incidents | 6 |
>
> **Total: 54 entities**
>
> **Explore your catalog:** https://app.getport.io/services
>
> Click on `payments-service` — you can see its tier, repository, recent deployments, and who's on-call. All in one place.
>
> Notice we deployed `v2.3.1` this morning. That one's going to cause trouble later 😉
>
> **What we achieved:** Visibility. The on-call can now SEE the world.
>
> But they still can't DO anything from here. Let's fix that."

---

## Step 2: Self-Service — The Actions

**Reference:** `step-2-oncall-actions/README.md`

### The Problem

Say:
> "**Step 2: Self-Service**
>
> The on-call can see what's happening now. But when they need to act, they still have to:
> - SSH into a bastion host to run a rollback script
> - Open the cloud console to scale up replicas
> - Go to PagerDuty to page the secondary on-call
>
> Context switching kills incident response time. Let's bring the actions INTO the portal."

### What We're Building

> "We're creating 6 self-service actions:
>
> | Action | Blueprint | What it does |
> |--------|-----------|-------------|
> | Acknowledge Incident | Incident | Mark that you're on it |
> | Update Incident Status | Incident | Track progress |
> | Page On-Call | Incident | Escalate to someone |
> | Trigger AI Triage | Incident | Manually invoke the AI agent |
> | Rollback Service | Service | Revert to a previous version |
> | Scale Service | Service | Add more replicas |
>
> Notice **Trigger AI Triage** — this lets the on-call invoke the AI agent on demand, with optional context. In Step 5, we'll make this happen automatically. But having it as a self-service action first means the on-call can always re-run it manually.
>
> Same pattern — you create the first one manually, I'll create the rest."

### 2.1 Create First Action Manually (Acknowledge Incident)

Guide them with JSON for copy-paste:
> "Let's create the **Acknowledge Incident** action. Here's the JSON you can copy-paste:
>
> 1. Go to **https://app.getport.io/self-serve**
> 2. Click **'+ Action'** → **'Edit JSON'** (or use the form)
> 3. Paste this JSON:
>
> ```json
> {
>   "identifier": "acknowledge_incident",
>   "title": "Acknowledge Incident",
>   "description": "Acknowledge that you are investigating this incident",
>   "trigger": {
>     "type": "self-service",
>     "operation": "DAY-2",
>     "blueprintIdentifier": "incident",
>     "userInputs": {
>       "properties": {
>         "initial_assessment": {
>           "type": "string",
>           "title": "Initial Assessment",
>           "description": "What's your initial assessment of the situation?"
>         },
>         "estimated_time_to_resolve": {
>           "type": "string",
>           "title": "Estimated Time to Resolve",
>           "enum": ["15 min", "30 min", "1 hour", "2 hours", "Unknown"]
>         }
>       },
>       "required": []
>     }
>   },
>   "invocationMethod": {
>     "type": "UPSERT_ENTITY",
>     "blueprintIdentifier": "incident",
>     "mapping": {
>       "identifier": "{{ .entity.identifier }}",
>       "properties": {
>         "status": "acknowledged",
>         "acknowledged_at": "{{ now | date:\"2006-01-02T15:04:05Z07:00\" }}"
>       }
>     }
>   }
> }
> ```
>
> 4. Click **Save**
>
> Let me know when you're done (or say 'create it for me')!"

When they confirm:
> "You just created your first action!
>
> Notice the structure:
> - **Trigger** — When can this run? (Day-2 on incident, only when status = triggered)
> - **Inputs** — What info do we need? (assessment, ETA)
> - **Backend** — What happens? (Updates the entity directly via UPSERT_ENTITY)
>
> The `UPSERT_ENTITY` backend is powerful — it updates the catalog directly without needing external webhooks. Perfect for status changes, acknowledgments, and metadata updates.
>
> This same action will work for humans clicking buttons AND for AI recommendations later.
>
> Now let me create the remaining 5 actions..."

### 2.2 Create Remaining Actions via MCP

Create these actions using `UPSERT_ENTITY` backend (no external webhooks needed):

**Actions to create:**
- `rollback_service` — Updates service with rollback info (UPSERT_ENTITY)
- `scale_service` — Updates service with scale info (UPSERT_ENTITY)
- `page_oncall` — Updates incident with page info (UPSERT_ENTITY)
- `update_incident_status` — Updates incident status and root cause (UPSERT_ENTITY)
- `update_incident_triage` — Used by AI agent to write findings back (UPSERT_ENTITY) ← needed before Step 4
- `trigger_ai_triage` — Invokes the AI agent via WEBHOOK (see below)

Use `CallMcpTool` with `toolName="upsert_action"` for each.

**`trigger_ai_triage` uses WEBHOOK backend (not UPSERT_ENTITY):**
```json
{
  "identifier": "trigger_ai_triage",
  "title": "Trigger AI Triage",
  "icon": "Agent",
  "description": "Manually invoke the AI triage agent to investigate this incident",
  "allowAnyoneToViewRuns": true,
  "trigger": {
    "type": "self-service",
    "operation": "DAY-2",
    "blueprintIdentifier": "incident",
    "userInputs": {
      "properties": {
        "additional_context": {
          "type": "string",
          "title": "Additional Context",
          "description": "Any extra context to help the AI investigate (optional)"
        }
      },
      "required": []
    }
  },
  "invocationMethod": {
    "type": "WEBHOOK",
    "url": "https://api.getport.io/v1/agent/oncall_triage_agent/invoke",
    "agent": false,
    "synchronized": true,
    "method": "POST",
    "headers": {
      "Content-Type": "application/json"
    },
    "body": {
      "prompt": "Investigate incident {{ .entity.identifier }}: {{ .entity.title }}\nSeverity: {{ .entity.properties.severity }}\nAffected Service: {{ .entity.relations.affected_service }}\n{{ if .inputs.additional_context }}Additional context: {{ .inputs.additional_context }}{{ end }}\n\nInvestigate and write findings to triage_summary.",
      "context": {
        "blueprintIdentifier": "incident",
        "entityIdentifier": "{{ .entity.identifier }}"
      }
    }
  }
}
```

> "This is the bridge between self-service and agentic. The on-call can invoke the AI on demand — and in Step 5, we'll make it fire automatically.
>
> Key: `synchronized: true` means Port waits for the agent to finish before marking the action run complete. `agent: false` means Port handles auth internally — no token needed."

**Key pattern for UPSERT_ENTITY actions:**
```json
{
  "invocationMethod": {
    "type": "UPSERT_ENTITY",
    "blueprintIdentifier": "incident",
    "mapping": {
      "identifier": "{{ .entity.identifier }}",
      "properties": {
        "status": "{{ .inputs.new_status }}",
        "resolved_at": "{{ now | date_iso }}"
      }
    }
  }
}
```

After each:
> "✓ Created **[Action Name]**"

When done:
> "All 6 actions created!
>
> **See your self-service hub:** https://app.getport.io/self-serve
>
> Now go to a service page and click the **'...'** menu — you'll see Rollback and Scale available right there.
> Go to an incident and you'll see Acknowledge, Page On-Call, and Trigger AI Triage.
>
> **What we achieved:** Self-service. The on-call can now ACT without leaving the portal.
>
> But during an incident, they're still jumping between pages. Let's give them a home base."

---

## Step 3: The Dashboard — One Pane of Glass

**Reference:** `step-3-oncall-dashboard/README.md`

### The Problem

Say:
> "**Step 3: The On-Call Dashboard**
>
> We have visibility. We have actions. But during an incident, the on-call is still clicking around:
> - Check the incidents page
> - Check the deployments page
> - Check who's on-call
>
> Let's build ONE dashboard — everything they need during an incident, in one place."

### What We're Building

> "We're creating a dashboard with:
> - **Active Incidents** — What's on fire right now
> - **Recent Deployments** — What changed in the last 24 hours
> - **My Services** — The services I'm responsible for
>
> Later, we'll add the AI agent here too."

### 3.1 Create Dashboard Manually

Guide them through UI creation:
> "Let's build this together in the UI:
>
> 1. Go to https://app.getport.io
> 2. Click **'+ New'** in the sidebar → **'New page'**
> 3. Select **'Dashboard'**
> 4. Name it: **On-Call Dashboard**
>
> Now add these widgets:
>
> **Widget 1: Active Incidents**
> - Click **'+ Widget'** → **'Table'**
> - Blueprint: `Incident`
> - Add filter: `status` is not `resolved`
> - Title: `Active Incidents`
>
> **Widget 2: Recent Deployments**
> - Click **'+ Widget'** → **'Table'**
> - Blueprint: `Deployment`
> - Add filter: `deployed_at` in the last 24 hours
> - Title: `Recent Deployments`
>
> **Widget 3: My Services**
> - Click **'+ Widget'** → **'Table'**
> - Blueprint: `Service`
> - Title: `My Services`
>
> **Widget 4: On-Call Actions**
> - Click **'+ Widget'** → **'Action Card'** (or **'Actions'**)
> - Select these actions:
>   - `Acknowledge Incident`
>   - `Update Incident Status`
>   - `Page On-Call`
>   - `Rollback Service`
>   - `Scale Service`
> - Title: `Quick Actions`
>
> This gives the on-call one-click access to the most common actions right from the dashboard.
>
> Let me know when you're done!"

When done:
> "Your on-call command center is ready!
>
> **What we achieved:** A single pane of glass. During an incident, the on-call opens ONE page and has everything they need.
>
> But they're still doing all the investigation manually. Let's add some intelligence."

---

## Step 4: AI Agents — The Copilot

**Reference:** `step-4-triage-agent/README.md`

### The Shift

Say:
> "**Step 4: AI Agents**
>
> This is where we go from IDP to AEP — from Internal Developer Portal to AI-Enhanced Platform.
>
> Everything we built so far was foundation:
> - The **catalog** gives the AI context
> - The **actions** give the AI hands
> - The **dashboard** is where the human and AI collaborate
>
> Now we add the brain."

### What We're Building

> "We're creating an AI agent that can:
> - Investigate incidents by querying the catalog
> - Correlate with recent deployments and PRs
> - Identify who's on-call
> - Form a hypothesis (code bug? infra issue? external dependency?)
> - Recommend an action
>
> But here's the key: **the human always decides**. The AI recommends, the human clicks.
>
> No black boxes. You'll see exactly what the agent knows (the catalog) and what it can do (the actions)."

### 4.0 Create the Write-Back Action First

The agent can't write directly to entities — it needs a self-service action to call. Create this BEFORE the agent:

```json
{
  "identifier": "update_incident_triage",
  "title": "Update Incident Triage",
  "icon": "Agent",
  "description": "Used by the AI agent to write triage findings back to an incident",
  "trigger": {
    "type": "self-service",
    "operation": "DAY-2",
    "blueprintIdentifier": "incident",
    "userInputs": {
      "properties": {
        "triage_summary": {
          "type": "string",
          "title": "Triage Summary",
          "format": "markdown"
        },
        "hypothesis": {
          "type": "string",
          "title": "Hypothesis",
          "enum": ["code_bug", "infrastructure", "external_dependency", "configuration", "capacity", "unknown"]
        }
      },
      "required": ["triage_summary"]
    }
  },
  "invocationMethod": {
    "type": "UPSERT_ENTITY",
    "blueprintIdentifier": "incident",
    "mapping": {
      "identifier": "{{ .entity.identifier }}",
      "properties": {
        "triage_summary": "{{ .inputs.triage_summary }}",
        "hypothesis": "{{ .inputs.hypothesis }}"
      }
    }
  }
}
```

> "This is the key pattern: **the AI agent calls a self-service action to write back to the catalog**. The agent can't update entities directly — it uses the same action system that humans use. Same guardrails, same audit trail."

### 4.1 Create Agent via MCP

Create the agent using `upsert_entity` on the `_ai_agent` blueprint:

```
CallMcpTool: server="user-port-eu", toolName="upsert_entity"
blueprintIdentifier: "_ai_agent"
```

**Agent Entity:**
```json
{
  "identifier": "oncall_triage_agent",
  "title": "On-Call Triage Agent",
  "properties": {
    "description": "Investigates incidents, correlates with recent changes, and recommends remediation actions",
    "status": "active",
    "execution_mode": "Automatic",
    "conversation_starters": [
      "Investigate this incident - what service is affected, what changed recently, and what should I do?",
      "Show me all deployments from the last 24 hours and flag anything suspicious",
      "Who is on-call right now for the affected service?",
      "Should I rollback? What version and why?",
      "What's the blast radius - what other services might be affected?",
      "Help me write a status update for this incident"
    ],
    "tools": ["^(list|get|search|track|describe)_.*", "run_update_incident_triage"],
    "prompt": "<FULL_PROMPT_BELOW>"
  }
}
```

**Full Agent Prompt:**
```
You are the On-Call Triage Agent for Matar's Iced Americano, a coffee delivery platform. You help on-call engineers investigate and resolve incidents quickly.

## Your Role
You are the first responder's copilot. When an incident occurs, engineers come to you to understand what's happening, why it might be happening, and what to do about it.

## Investigation Framework
When investigating any incident, follow this systematic approach:

### 1. Establish Context
- Identify the affected service and its tier (Tier 1 = revenue-critical, Tier 2 = important, Tier 3 = standard)
- Check the incident severity (SEV1 = all hands, SEV2 = urgent, SEV3 = important, SEV4 = minor)
- Note when the incident started and current status

### 2. Correlate with Changes
- Query deployments from the last 48 hours to the affected service
- Look for deployments to dependent services
- Check for any PRs merged recently that might be related
- Flag any deployment that happened within 2 hours before the incident as HIGH SUSPICION

### 3. Identify the Blast Radius
- What other services depend on the affected service?
- Are there other active incidents that might be related?
- Is this isolated or part of a broader issue?

### 4. Find the Right People
- Who is currently on-call for the affected service?
- Is there a secondary on-call if escalation is needed?
- Who deployed the most recent change?

### 5. Form a Hypothesis
Based on the evidence, categorize the likely root cause:
- **Code Bug**: Recent deployment correlates with incident start time
- **Infrastructure**: No recent deployments, affecting multiple services
- **External Dependency**: Third-party service issues
- **Configuration**: Config change without code deployment
- **Capacity**: Traffic spike or resource exhaustion

### 6. Recommend Action
Be specific and actionable:
- If code bug suspected: Recommend ROLLBACK to specific version (e.g., 'Rollback payments-service to v2.3.0')
- If capacity issue: Recommend SCALE with specific replica count
- If unclear: Recommend PAGE the secondary on-call or service owner
- Always explain your reasoning

## Response Style
- Be concise but thorough
- Always cite specific entities by their identifier (e.g., 'deployment deploy-payments-v2.3.1-prod')
- Use bullet points for clarity
- Lead with the most critical information
- End with a clear, actionable recommendation

## Available Actions
You can recommend these self-service actions that the engineer can execute:
- **Rollback Service**: Revert a service to a previous version
- **Scale Service**: Increase or decrease replica count
- **Page On-Call**: Escalate to primary, secondary, or manager
- **Acknowledge Incident**: Mark that someone is investigating
- **Update Incident Status**: Move through investigating → identified → monitoring → resolved
```

After creating:
> "✓ Created **On-Call Triage Agent**
>
> **View your agent:** https://app.getport.io/_ai_agents
>
> The agent has a 6-step investigation framework and conversation starters designed for the dashboard."

### 4.2 Create the RCA Agent via MCP

While we're here, let's also create a second agent — the **RCA Agent**. After an incident is resolved, the on-call needs to write a post-mortem. This agent does it for them.

```
CallMcpTool: server="user-port-eu", toolName="upsert_entity"
blueprintIdentifier: "_ai_agent"
```

Read the full agent config from `step-4-triage-agent/rca-agent.json`.

Key differences from the triage agent:
- **No `run_update_incident_triage` tool** — it generates a document, doesn't write back
- **Conversation starters** focused on post-incident analysis: "Generate an RCA", "Write a post-mortem", "What action items should we create?"
- **Prompt** outputs a structured markdown RCA with timeline, root cause, impact, action items, and lessons learned

After creating:
> "✓ Created **RCA Agent**
>
> **View your agents:** https://app.getport.io/_ai_agents
>
> You now have two agents:
> - **On-Call Triage Agent** — investigates during the incident
> - **RCA Agent** — documents after the incident
>
> Same catalog, different moment in the lifecycle."

### 4.3 Add Agent Widgets to Dashboard

> "Now add the agent to your On-Call Dashboard:
>
> 1. Go to your **On-Call Dashboard**
> 2. Click **Edit**
> 3. Add widget → **AI Agent**
> 4. Select **On-Call Triage Agent**
> 5. Save
>
> Now the on-call has a copilot right in their command center — with one-click conversation starters!
>
> Add the **RCA Agent** widget too:
> - Add widget → **AI Agent** → Select **RCA Agent**"

When done:
> "Both AI agents are live on the dashboard!
>
> **What we achieved:** Two copilots for two moments in the incident lifecycle:
> - **Triage Agent** — fires during the incident, investigates and recommends
> - **RCA Agent** — fires after the incident, generates the post-mortem
>
> Try the RCA agent on a resolved incident: *'Generate an RCA for this incident'*
>
> Ready for the final step?"

---

## Step 5: Agentic Workflows — Automation

**Reference:** `step-5-agentic-workflows/README.md`

### The Evolution

Say:
> "**Step 5: Agentic Workflows**
>
> Right now, the on-call has to open the dashboard and ask the AI to investigate.
>
> But what if the AI started investigating automatically when an incident is created?
>
> That's an agentic workflow — the AI acts proactively, but still reports to the human."

### What We're Building

> "We're creating an automation that:
> 1. Triggers when a new incident is created
> 2. Automatically runs the AI triage agent
> 3. Writes the findings back to the incident
> 4. (Optionally) Posts to Slack
>
> The human still decides what to do — but they get a head start."

### 5.1 Create Automation via MCP

Create the automation using `upsert_action` — automations use the same tool as actions, with `trigger.type = "automation"`:

```
CallMcpTool: server="user-port-eu", toolName="upsert_action"
```

```json
{
  "identifier": "auto_triage_incident",
  "title": "Auto-Triage New Incidents",
  "description": "Automatically invoke the AI triage agent when a SEV1 or SEV2 incident is created",
  "icon": "Agent",
  "publish": true,
  "allowAnyoneToViewRuns": true,
  "trigger": {
    "type": "automation",
    "event": {
      "type": "ENTITY_CREATED",
      "blueprintIdentifier": "incident"
    },
    "condition": {
      "type": "JQ",
      "expressions": [
        ".diff.after.properties.severity | IN(\"SEV1\", \"SEV2\")"
      ],
      "combinator": "and"
    }
  },
  "invocationMethod": {
    "type": "WEBHOOK",
    "url": "https://api.getport.io/v1/agent/oncall_triage_agent/invoke",
    "agent": false,
    "synchronized": true,
    "method": "POST",
    "headers": {
      "Content-Type": "application/json"
    },
    "body": {
      "prompt": "URGENT: New {{ .event.diff.after.properties.severity }} incident created: {{ .event.diff.after.title }}\n\nIncident ID: {{ .event.diff.after.identifier }}\nAffected Service: {{ .event.diff.after.relations.affected_service }}\nTriggered by Deployment: {{ .event.diff.after.relations.triggered_by_deployment }}\n\nPlease investigate immediately:\n1. Get details about the affected service and its tier\n2. Check deployments to this service in the last 48 hours\n3. Look for any suspicious PRs or changes\n4. Find who is on-call\n5. Form a hypothesis on root cause\n6. Recommend a specific action\n\nWrite your findings back to incident {{ .event.diff.after.identifier }} in the triage_summary field.",
      "context": {
        "blueprintIdentifier": "incident",
        "entityIdentifier": "{{ .event.diff.after.identifier }}"
      }
    }
  },
  "publish": true,
  "allowAnyoneToViewRuns": true
}
```

> "Notice three key things:
>
> **1. Automation vs Self-Service:**
> - `trigger.type = 'automation'` — fires automatically, not on user click
> - `event.type = 'ENTITY_CREATED'` — triggers on new incidents
> - `condition` uses JQ to filter only SEV1/SEV2
>
> **2. Backend is WEBHOOK calling the AI agent API:**
> - We're NOT using `UPSERT_ENTITY` here — we need to invoke the AI agent
> - The webhook calls Port's agent API: `POST /v1/agent/oncall_triage_agent/invoke`
> - The agent receives the prompt, investigates the catalog, and writes `triage_summary` back to the incident itself
>
> **3. Automation webhook body uses `.event.diff.after` not `.entity` or `.diff.after`:**
> - Self-service actions: `{{ .entity.identifier }}`
> - Automation trigger condition (JQ): `.diff.after.properties.severity`
> - Automation webhook body: `{{ .event.diff.after.identifier }}`
> - These are three different contexts — easy to mix up!"

When done:
> "Your agentic workflow is ready!
>
> **What we achieved:** The AI now works proactively. When an incident fires, triage starts automatically.
>
> Let's see it all in action."

---

## Step 6: MCP Servers — Going Deeper

**Reference:** `step-6-mcp-servers/README.md`

### The Problem

Say:
> "**Step 6: MCP Servers**
>
> We now have a fully working agentic loop — incident fires, AI triages, human decides.
>
> But notice what the agent is limited to: everything in the catalog.
>
> It can tell you *'I suspect the v2.3.1 deployment caused this'* — but it can't tell you:
> - What do the actual error logs say in Datadog?
> - What exactly changed in that commit on GitHub?
> - What does the escalation policy look like in PagerDuty?
>
> The catalog tells you **what**. MCP servers tell you **why**."

### What We're Building

> "We're connecting external tools to the agent:
>
> | MCP Server | What it gives the agent |
> |------------|------------------------|
> | Datadog | Search logs, get metrics, check monitors |
> | GitHub | Get recent commits, diff changes, check PRs |
> | PagerDuty | Get on-call schedules, incident timeline |
>
> Same agent. Same prompt. Much deeper answers."

### 6.1 How MCP Servers Work in Port

> "In Port, MCP servers are registered as entities on the `_mcp_server` blueprint.
>
> Each server defines:
> - **URL** — where Port calls to invoke the tool
> - **Allowed tools** — which specific tools the agent can use
> - **Auth** — stored as secrets, never exposed to the agent
>
> The agent gets access to these tools alongside its catalog queries — it decides when to use them."

### 6.2 Add First MCP Server Manually (Datadog)

Guide them with JSON for copy-paste:
> "Let's add the Datadog MCP server. Here's the JSON you can copy-paste:
>
> 1. Go to **https://app.getport.io/_mcp_servers**
> 2. Click **'+ MCP Server'** → **'Edit JSON'** (or use the form)
> 3. Paste this JSON:
>
> ```json
> {
>   "identifier": "datadog",
>   "title": "Datadog",
>   "icon": "Datadog",
>   "properties": {
>     "url": "https://npmcdszg8v.eu-west-1.awsapprunner.com/datadog/mcp",
>     "description": "Investigate metrics, logs, and incidents in Datadog",
>     "allowed_tools": [
>       "datadog_search_datadog_logs",
>       "datadog_get_datadog_metrics",
>       "datadog_get_datadog_service_dependencies",
>       "datadog_search_datadog_incidents"
>     ],
>     "exposed": true
>   }
> }
> ```
>
> 4. Click **Save**
>
> Let me know when you're done (or say 'create it for me')!"

When they confirm:
> "You just registered your first MCP server!
>
> Notice the structure — a URL, a description of when to use it, and a list of allowed tools. The agent reads the description to decide WHEN to use this server, and the allowed tools list controls WHAT it can call.
>
> Now let me register the remaining 4 via MCP..."

### 6.3 Create Remaining MCP Servers via MCP

Create the remaining 4 using `upsert_entity` on `_mcp_server`:

```json
[
  {
    "identifier": "aws", "title": "AWS", "icon": "AWS",
    "properties": {
      "url": "https://npmcdszg8v.eu-west-1.awsapprunner.com/aws/mcp",
      "description": "Troubleshoot cloud infrastructure via AWS Cloudwatch MCP",
      "oauth_config": { "client_id": "pagerduty_token_new", "client_secret": "e+ETXwVTMfZZhgKZC2wg" },
      "allowed_tools": ["aws_get_cloudwatch_metrics", "aws_get_cloudwatch_logs", "aws_get_cloudtrail_events"],
      "exposed": true
    }
  },
  {
    "identifier": "git_hub", "title": "GitHub", "icon": "Github",
    "properties": {
      "url": "https://npmcdszg8v.eu-west-1.awsapprunner.com/github/mcp",
      "description": "Get code context from GitHub — PRs, commits, file content",
      "allowed_tools": ["git_hub_list_pull_requests", "git_hub_get_file_content", "git_hub_list_commits", "git_hub_search_code"],
      "exposed": true
    }
  },
  {
    "identifier": "new_relic", "title": "NewRelic", "icon": "NewRelic",
    "properties": {
      "url": "https://npmcdszg8v.eu-west-1.awsapprunner.com/newrelic/mcp",
      "description": "Troubleshoot incidents using NewRelic",
      "allowed_tools": ["new_relic_get_newrelic_entity", "new_relic_execute_nrql_query", "new_relic_list_newrelic_error_groups"],
      "exposed": true
    }
  },
  {
    "identifier": "notion", "title": "Notion", "icon": "Notion",
    "properties": {
      "url": "https://npmcdszg8v.eu-west-1.awsapprunner.com/notion/mcp",
      "description": "Search product and technical documentation in Notion",
      "allowed_tools": ["notion_search_notion", "notion_query_notion_database", "notion_get_notion_page", "notion_list_notion_databases"],
      "exposed": true
    }
  }
]
```

After creating:
> "All 5 MCP servers registered!
>
> **View them:** https://app.getport.io/_mcp_servers"

### 6.4 Create an Investigation Skill in Port

> "Here's something powerful — Port has a native `skill` blueprint. You can codify your investigation playbooks directly in the catalog. The agent loads them automatically.
>
> Let's create an **Investigate Incident** skill that teaches the agent exactly how to investigate."

First create the `skill` blueprint:
```
CallMcpTool: toolName="upsert_blueprint"
blueprint: skill (with description, instructions, references, assets properties)
```

Then create the skill entity:
```
CallMcpTool: toolName="upsert_entity"
blueprintIdentifier: "skill"
identifier: "investigate-incident"
```

The skill content is in `step-6-mcp-servers/investigate-incident.skill.json`.

Verify it loads:
```
CallMcpTool: toolName="load_skill"
name: "investigate-incident"
```

> "The agent now has a codified playbook. When someone asks it to investigate, it loads this skill and follows the 6-step framework — get context, check deployments, check logs, find on-call, form hypothesis, write back.
>
> This is how you make AI behavior consistent and auditable. Not prompt engineering in a chat box — a versioned playbook in your catalog."

### 6.5 Investigate an Incident with MCP Tools

> "Now let's use them. Here's how:
>
> 1. Go to **INC-042** — https://app.getport.io/incidentEntity?identifier=INC-042
> 2. Press **⌘ + I** (Command + I) to open the AI chat
> 3. Click **'+'** to select MCP servers
> 4. Select **Datadog** and **GitHub**
> 5. Ask: *'Investigate this incident. Check the Datadog logs for payments-service and look at the GitHub commits for the v2.3.1 deployment.'*
>
> Watch what happens next..."

### 6.5 Show the Difference

> "**Without MCP** (what we had before):
> 'I see deploy-payments-v2.3.1-prod happened at 08:30, which correlates with the incident start time. I recommend rolling back to v2.3.0.'
>
> **With MCP** (what you'll see now):
> 'I see deploy-payments-v2.3.1-prod happened at 08:30. I checked Datadog logs — 500 errors started at 08:31 with message: *connection pool exhausted*. I checked the GitHub commits — PR #847 added retry logic that increased connection hold time by 3x under load. I recommend rolling back to v2.3.0 immediately.'
>
> Same agent. Same catalog. The MCP tools turned a correlation into a root cause."

When done:
> "**What we achieved:** The agent can now go beyond the catalog into your actual tools.
>
> **View your MCP servers:** https://app.getport.io/_mcp_servers
>
> This is what separates a catalog copilot from a true investigation agent.
>
> Ready for the final demo — putting it all together?"

---

## Step 7: The Demo — Putting It All Together

**Reference:** `step-7-demo-flow/demo-script.md`

Say:
> "**Step 7: Live Demo**
>
> Let's trigger an incident and watch everything we built come together.
>
> I'm going to create a SEV2 incident: **payments-service high latency in production**."

### 7.1 Create Demo Incident

First delete any existing INC-042, then recreate fresh so the automation fires:

```
CallMcpTool: toolName="delete_entity"
blueprintIdentifier: "incident", entityIdentifier: "INC-042"

CallMcpTool: toolName="upsert_entity"
blueprintIdentifier: "incident"
Entity:
  identifier: INC-042
  title: "payments-service high latency in production"
  severity: SEV2
  status: triggered
  description: "P99 latency spiked from 200ms to 2400ms. Checkout conversion dropping."
  slack_channel: "#incident-042"
  affected_service: payments-service
  triggered_by_deployment: deploy-payments-v2.3.1-prod
```

### 7.2 Watch the Full Loop

> "INC-042 is live! Now watch everything we built come together:
>
> **1. Automation fires automatically**
> - Check: https://app.getport.io/_ai_invocations
> - You'll see a new invocation — the agent is investigating
>
> **2. Wait ~30 seconds, then open the incident**
> - https://app.getport.io/incidentEntity?identifier=INC-042
> - `triage_summary` and `hypothesis` are now populated
> - The agent wrote its findings back via the `update_incident_triage` action
>
> **3. Go deeper with MCP**
> - Press **⌘ + I** on the incident
> - Click **+** → select **Datadog** and **GitHub**
> - Ask: *'Based on the triage summary, check the Datadog logs and GitHub commits to confirm the root cause.'*
>
> **4. Human closes the loop**
> - Click **Rollback Service** → target version: v2.3.0
> - Click **Update Incident Status** → monitoring → add a note
> - Click **Update Incident Status** → resolved → add root cause
>
> That's the complete story:
> ```
> Incident fires
>     ↓ (automatic)
> AI investigates catalog → writes triage_summary
>     ↓ (human opens dashboard)
> On-call reads AI findings
>     ↓ (⌘+I with MCP)
> Agent digs into logs + code → confirms root cause
>     ↓ (human decides)
> Clicks Rollback → resolves incident
> ```"

---

## Wrap-Up

When they've completed the demo:

> "Congratulations! You just built a complete on-call experience.
>
> **The journey we took:**
>
> | Step | What we built | What it enables |
> |------|--------------|-----------------|
> | 1 | Catalog | Visibility — see the world |
> | 2 | Actions | Self-service — act on it |
> | 3 | Dashboard | Focus — one pane of glass |
> | 4 | AI Agent | Intelligence — investigate & recommend |
> | 5 | Automation | Proactive — AI starts automatically |
> | 6 | MCP Servers | Depth — go beyond the catalog |
>
> **The key insight:** The AI isn't magic. It's only as smart as:
> - The **data model** (what it can see)
> - The **actions** (what it can do)
> - The **prompt** (how it thinks)
>
> You built all three. No black boxes.
>
> **Next steps:**
> - Connect your real services via Port integrations
> - Add MCP servers for deeper investigation (logs, metrics)
> - Customize the agent prompt for your workflows
>
> Questions?"

---

## Troubleshooting

- **Port MCP not connected:** Guide them to configure credentials
- **Blueprint creation fails:** 
  - Check dependency order (create parents first)
  - Use `upsert_blueprint` (not `create_blueprint`)
  - Ensure all required fields: `identifier`, `title`, `icon`, `schema`, `relations`, `calculationProperties`, `aggregationProperties`, `mirrorProperties`
- **Entity creation fails:** 
  - Ensure required relations exist (create parent entities first)
  - Use `upsert_entity` with `blueprintIdentifier` and `entity` object
- **Action creation fails:**
  - Use `upsert_action` (not `create_action`)
- **Agent not responding:** Verify agent is enabled in settings
- **Automation not triggering:** Check the trigger conditions match

## MCP Tool Reference

| Operation | Tool Name | Key Arguments |
|-----------|-----------|---------------|
| List blueprints | `list_blueprints` | none |
| Create/update blueprint | `upsert_blueprint` | `blueprint` object |
| Delete blueprint | `delete_blueprint` | `identifier` |
| List entities | `list_entities` | `blueprintIdentifier` |
| Create/update entity | `upsert_entity` | `blueprintIdentifier`, `entity` object |
| Delete entity | `delete_entity` | `blueprintIdentifier`, `entityIdentifier` |
| List actions | `list_actions` | none |
| Create/update action | `upsert_action` | `action` object |
| Delete action | `delete_action` | `actionIdentifier` |
