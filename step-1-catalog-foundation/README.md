# Step 1: Catalog Foundation — Visibility

## What We're Building

7 blueprints that give the AI (and the on-call engineer) a complete picture of the engineering world.

## The Problem

Right now, when an incident happens, the on-call has to:
- Check Slack to figure out which service is affected
- SSH into servers to see what's deployed
- Dig through PagerDuty to find who's on-call
- Manually correlate "did someone deploy recently?"

That's chaos. The catalog fixes it.

## Blueprints (create in this order — dependencies matter)

| # | Blueprint | Depends On | Why |
|---|-----------|-----------|-----|
| 1 | `environment` | — | Know if it's prod or staging |
| 2 | `repository` | — | Link code to services |
| 3 | `service` | repository | The thing that's on fire |
| 4 | `pull_request` | repository | What code changed recently |
| 5 | `deployment` | service, environment | When and what was deployed |
| 6 | `incident` | service, deployment | Track the fire |
| 7 | `oncall_schedule` | service | Who to call |

## Files

| File | Blueprint |
|------|-----------|
| `environment.blueprint.json` | Environment |
| `repository.blueprint.json` | Repository |
| `service.blueprint.json` | Service |
| `pull_request.blueprint.json` | Pull Request |
| `deployment.blueprint.json` | Deployment |
| `incident.blueprint.json` | Incident |
| `oncall-schedule.blueprint.json` | On-Call Schedule |

## Key Design Decisions

**`incident.blueprint.json`** has two special fields:
- `triage_summary` — written by the AI agent after investigation
- `hypothesis` — the agent's root cause category (code_bug, infrastructure, etc.)

**`deployment.blueprint.json`** has a calculated `age` field — shows "2h ago" dynamically.

**`oncall_schedule.blueprint.json`** has a calculated `is_active` field — true if the schedule covers right now.

## Sample Data

See `../sample-data/` for demo entities:
- 6 environments, 8 repositories, 8 services
- 10 deployments (including the "bad" v2.3.1 for the demo)
- 8 pull requests, 8 on-call schedules
- 6 incidents (mix of resolved + active)
