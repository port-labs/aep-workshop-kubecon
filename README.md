# From IDP to AEP: Building an AI-Enhanced Platform

**KubeCon Workshop** · 2 hours · Port + Your IDE

---

## What We're Building

An on-call incident response system that evolves from a basic catalog to a fully agentic platform — step by step.

By the end, when a production incident fires:
1. The AI agent **automatically investigates** — correlates deployments, checks who's on-call
2. It **writes findings** back to the incident entity
3. The on-call opens the dashboard and sees the analysis **already done**
4. They open AI chat, pull in Datadog logs and GitHub commits to confirm
5. They click **Rollback** — one button, done

No magic. Just good data, good prompts, and good actions.

---

## How to Start the Workshop

**You need:**
- A [Port account](https://app.getport.io/signup) (free tier works)
- An IDE with MCP support: **Cursor**, **VS Code**, or any MCP-compatible editor

**Then:**

1. Clone this repo:
```bash
git clone https://github.com/port-labs/aep-workshop-kubecon
cd aep-workshop-kubecon
```

2. Configure the Port MCP for your IDE (see setup instructions below)

3. Start the workshop — pick your IDE:

---

## MCP Setup by IDE

### Cursor

1. Add this to your `~/.cursor/mcp.json`:
```json
{
  "mcpServers": {
    "port": {
      "url": "https://mcp.port.io/v1"
    }
  }
}
```

2. Restart Cursor, then authenticate when prompted

3. Open this repo and say: **"Start the AEP workshop"**

The workshop skill at `.cursor/skills/aep-workshop-builder/SKILL.md` is picked up automatically.

---

### VS Code

1. Install the [MCP extension for VS Code](https://marketplace.visualstudio.com/items?itemName=anthropics.claude-mcp) (or use GitHub Copilot with MCP support)

2. Add the Port MCP to your VS Code settings. Open **Settings (JSON)** and add:
```json
{
  "mcp.servers": {
    "port": {
      "url": "https://mcp.port.io/v1"
    }
  }
}
```

Or create/edit `.vscode/mcp.json` in your workspace:
```json
{
  "mcpServers": {
    "port": {
      "url": "https://mcp.port.io/v1"
    }
  }
}
```

3. Restart VS Code, then authenticate when prompted

4. Open AI chat and say: **"Start the AEP workshop"**

> **Tip:** The `.github/copilot-instructions.md` file provides workshop context for GitHub Copilot automatically.

---

### Other MCP-Compatible Editors

For any editor that supports MCP (Claude Desktop, Windsurf, etc.):

1. Add the Port MCP server with URL: `https://mcp.port.io/v1`
2. Authenticate with your Port account when prompted
3. Copy the contents of `.cursor/skills/aep-workshop-builder/SKILL.md` into your AI chat
4. Say: **"Follow this workshop guide and start from the beginning"**

---

### No AI — Manual Mode

Each step folder has a `README.md` and JSON files. Follow the READMEs in order and push configs via the Port UI at **https://app.getport.io**.

---

## Region Configuration

The MCP URL is region-specific:
- **US region:** `https://mcp.port.io/v1`
- **EU region:** `https://mcp.port-eu.io/v1`

Check your region at **https://app.getport.io/settings/credentials**

---

## The Journey

```
No visibility  →  Catalog  →  Self-Service  →  Dashboard  →  AI Agent  →  Automation  →  MCP Servers  →  Demo
   (chaos)        (see)        (act)           (focus)      (investigate)   (automate)    (go deeper)
```

| Step | What We Build | What It Enables |
|------|--------------|-----------------|
| 0 | Portal branding | Make it yours |
| 1 | Catalog — 7 blueprints, 54 entities | Visibility — see the world |
| 2 | 6 self-service actions | Act without leaving the portal |
| 3 | On-Call Dashboard | One pane of glass |
| 4 | AI Triage Agent | Investigate & recommend |
| 5 | Auto-triage automation | AI fires proactively on new incidents |
| 6 | MCP Servers (Datadog, GitHub, AWS...) | Go beyond the catalog |
| 7 | Live demo | Watch it all work together |

---

## The Scenario

We're building for **Matar's Iced Americano** ☕ — a fictional coffee delivery platform.

The demo incident: `payments-service` high latency in production, caused by a bad deployment (`v2.3.1`) that went out this morning.

The agent will figure this out on its own. See [company-context.md](company-context.md) for the full backstory.

---

## Repo Structure

```
├── README.md                          # You are here
├── company-context.md                 # Matar's Iced Americano — the fictional company
├── .cursor/
│   └── skills/
│       └── aep-workshop-builder/
│           └── SKILL.md               # ← The workshop skill. Say "start the workshop" in Cursor
├── step-0-portal-setup/               # Portal branding: name, logo
├── step-1-catalog-foundation/         # 7 blueprint JSON files
├── step-2-oncall-actions/             # 6 action JSON files
├── step-3-oncall-dashboard/           # Dashboard widget config
├── step-4-triage-agent/               # Agent prompt + conversation starters
├── step-5-agentic-workflows/          # Auto-triage automation JSON
├── step-6-mcp-servers/                # MCP server configs (Datadog, GitHub, AWS, NewRelic, Notion)
├── step-7-demo-flow/                  # Demo script + incident trigger
└── sample-data/                       # 54 demo entities for the catalog
```

Each step folder has:
- A `README.md` explaining what we're building and why
- JSON config files you can reference or push via MCP

---

## Key Concepts

**Why does the AI need a catalog?**
The agent can only reason about what it can see. The catalog is its world model — services, deployments, incidents, who's on-call. Without it, the agent is blind.

**Why UPSERT_ENTITY for actions?**
Most actions in this workshop update the catalog directly — no external webhooks needed. The agent writes its triage findings back to the incident the same way a human would click a button.

**Why MCP servers?**
The catalog tells you *what* happened. MCP servers tell you *why*. Datadog logs, GitHub commits, NewRelic traces — the agent can pull these in real time during investigation.

**Human in the loop?**
Always. The agent investigates and recommends. The human decides and clicks. Same actions, same audit trail.

---

## Resources

- [Port Documentation](https://docs.getport.io)
- [Port MCP Setup](https://docs.getport.io/guides-and-tutorials/setup-port-mcp)
- [AI Agents in Port](https://docs.getport.io/ai-interfaces/ai-agents/overview)
- [Port Free Tier](https://app.getport.io/signup)

---

Built with ☕ for KubeCon
