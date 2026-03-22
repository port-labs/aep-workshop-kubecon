# AEP Workshop — Copilot Instructions

This repo is a hands-on workshop for building an AI-Enhanced Platform (AEP) with Port.

## Context

We're building an on-call incident response system for a fictional company called **Matar's Iced Americano** ☕ — a coffee delivery platform.

The workshop builds in 7 steps:
1. Catalog foundation (7 blueprints, 54 entities)
2. Self-service actions (6 actions)
3. On-Call Dashboard
4. AI Triage Agent
5. Agentic automation (auto-triage on new incidents)
6. MCP Servers (Datadog, GitHub, AWS, NewRelic, Notion)
7. Live demo

## How to Use This Repo

- Each `step-N-*/` folder has a `README.md` and JSON config files
- JSON files are pushed to Port via the Port MCP or UI
- The full interactive guide is in `.cursor/skills/aep-workshop-builder/SKILL.md`

## Port MCP Tool Reference

| Operation | Tool | Key Args |
|-----------|------|----------|
| Create/update blueprint | `upsert_blueprint` | `blueprint` object |
| Create/update entity | `upsert_entity` | `blueprintIdentifier`, `entity` |
| Create/update action | `upsert_action` | `action` object |
| Delete entity | `delete_entity` | `blueprintIdentifier`, `entityIdentifier` |

## Key Patterns

**Self-service action body:** `{{ .entity.identifier }}`
**Automation trigger condition (JQ):** `.diff.after.properties.severity`
**Automation webhook body:** `{{ .event.diff.after.identifier }}`

When asked to "start the workshop" or help with a step, read the relevant step README and JSON files, then guide the user through creating the resources in Port.
