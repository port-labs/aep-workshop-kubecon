# Step 6: MCP Servers — Going Deeper

## What We're Building

External tool connections that let the AI agent go beyond the catalog — into real logs, metrics, and code.

## The Problem

After Step 5, the agent can say:
> "I see deploy-payments-v2.3.1-prod happened at 08:30, which correlates with the incident start time."

But it can't say:
> "I checked Datadog — 500 errors started at 08:31 with message: connection pool exhausted. I checked the GitHub commit — the retry logic change increased connection hold time by 3x."

The catalog tells you **what**. MCP servers tell you **why**.

## How MCP Servers Work in Port

MCP servers are registered as entities on the `_mcp_server` blueprint. Each defines:
- **URL** — where Port calls to invoke the tool
- **Description** — how the agent decides when to use it
- **Allowed tools** — which specific tools are available
- **Auth** — stored as secrets, never exposed to the agent

## Demo MCP Servers

These are real demo servers that respond with realistic data — perfect for the workshop.

**File:** `mcp-servers.json`

| Server | URL | Key Tools |
|--------|-----|-----------|
| Datadog | `...awsapprunner.com/datadog/mcp` | search_logs, get_metrics, get_service_dependencies |
| GitHub | `...awsapprunner.com/github/mcp` | list_commits, list_pull_requests, get_file_content |
| AWS | `...awsapprunner.com/aws/mcp` | get_cloudwatch_metrics, get_cloudwatch_logs |
| NewRelic | `...awsapprunner.com/newrelic/mcp` | execute_nrql_query, list_error_groups |
| Notion | `...awsapprunner.com/notion/mcp` | search_notion, get_notion_page |

## How to Use in Port

1. Go to **https://app.getport.io/_mcp_servers**
2. Add the first one **manually** (select **Custom**, not the native Datadog option)
3. Create the remaining 4 via MCP using `mcp-servers.json`

## Investigating with MCP

1. Open an incident page
2. Press **⌘ + I** to open the AI chat
3. Click **+** to select MCP servers (Datadog + GitHub recommended)
4. Ask: *"Investigate this incident. Check the Datadog logs and GitHub commits for the v2.3.1 deployment."*

## Port Skills — Teaching the Agent How to Investigate

Port has a native `skill` blueprint that lets you codify investigation playbooks directly in the catalog. The agent loads these skills automatically when triggered.

**File:** `investigate-incident.skill.json`

This skill teaches the agent the 6-step investigation framework:
1. Get incident context
2. Check recent deployments (flag HIGH SUSPICION within 2h of incident)
3. Check external tools (Datadog logs, GitHub commits)
4. Find who's on-call
5. Form a hypothesis
6. Write findings back via `update_incident_triage`

### How to create it

1. First create the `skill` blueprint via MCP (`upsert_blueprint`)
2. Then create the skill entity via MCP (`upsert_entity` on `skill` blueprint)
3. Verify it loads: `load_skill({ name: "investigate-incident" })`

The agent will now automatically load this playbook when asked to investigate an incident.
