# Sample Data

Demo entities for Matar's Iced Americano ☕ — push these to Port to populate the catalog.

## Files & Load Order

Load in this order (parents before children):

| # | File | Blueprint | Count |
|---|------|-----------|-------|
| 1 | `environments.json` | Environment | 6 |
| 2 | `repositories.json` | Repository | 8 |
| 3 | `services.json` | Service | 8 |
| 4 | `pull-requests.json` | Pull Request | 8 |
| 5 | `deployments.json` | Deployment | 10 |
| 6 | `oncall-schedules.json` | On-Call Schedule | 8 |
| 7 | `incidents.json` | Incident | 7 (mix of resolved + active) |
| 8 | `demo-incident.json` | Incident | 1 (create LAST — triggers automation) |

**Total: 56 entities**

## The Key Entities

**`deploy-payments-v2.3.1-prod`** — deployed today (the "bad" deployment)
- This is what the AI agent will correlate with INC-042
- Rollback target: `v2.3.0`

**`INC-042`** (demo-incident.json) — create this last
- SEV2, payments-service high latency
- Creating this triggers the auto-triage automation
- The AI agent will investigate and write back to `triage_summary`

## How to Load

### Via Port MCP (recommended)
Use `upsert_entity` for each entity in the files above.

### Via Port UI
Go to each blueprint page and create entities manually using the data in these files.
