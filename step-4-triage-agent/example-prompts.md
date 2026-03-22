# Example Agent Interactions

Real examples of how the triage agent helps during incidents.

---

## Example 1: Investigating an Incident

**User:** Investigate incident INC-042

**Agent:**

## Incident INC-042: payments-service high latency

| Field | Value |
|-------|-------|
| **Severity** | SEV2 |
| **Status** | Investigating |
| **Affected Service** | payments-service (Tier 1) |
| **Triggered** | 15 minutes ago |
| **On-Call** | alice@acme.com |

### Recent Deployments (Last 48h)

| Time | Version | Environment | Deployed By | Commit |
|------|---------|-------------|-------------|--------|
| 45 min ago | v2.3.1 | production | alice@acme.com | "Add retry logic for payment processor" |
| 2 days ago | v2.3.0 | production | bob@acme.com | "Update SDK version" |

### Dependencies
- **Upstream:** checkout-service, mobile-api
- **Downstream:** payment-processor (external), postgres-payments

### Hypothesis: **code_bug** (High confidence)

The timing strongly suggests the v2.3.1 deployment is the cause:
- Latency spike started ~30 minutes after deployment
- The commit adds retry logic, which could cause cascading delays
- No infrastructure changes in this timeframe
- External dependency (payment-processor) shows normal latency

### Recommended Actions

1. **Rollback to v2.3.0** — Safest immediate action given the correlation
2. **Check Datadog** — Verify the latency pattern matches deploy time
3. **Review the retry logic** — Look for missing backoff or timeout issues

Would you like me to initiate a rollback to v2.3.0?

---

## Example 2: Recent Changes Query

**User:** What changed in checkout-service in the last 24 hours?

**Agent:**

## checkout-service Changes (Last 24h)

### Deployments
| Time | Version | Environment | By | Status |
|------|---------|-------------|----|--------|
| 6h ago | v1.8.1 | production | carol@acme.com | ✅ Succeeded |
| 8h ago | v1.8.1 | staging | carol@acme.com | ✅ Succeeded |

### Deployment Details: v1.8.1
**Commit:** `a1b2c3d` — "Fix cart calculation for discounts"
**PR:** #892 — Reviewed by: dave@acme.com
**Changes:** 
- Modified `cart/calculator.go` (+45, -12)
- Updated unit tests (+30)

### Related Activity
- No config changes
- No infrastructure changes
- No open incidents

### Summary
One deployment (v1.8.1) fixing a cart calculation bug. Deployed to staging, then production. No issues reported.

---

## Example 3: Blast Radius Analysis

**User:** What's the blast radius if payments-service goes down?

**Agent:**

## Blast Radius: payments-service

```
                    ┌─────────────────┐
                    │ mobile-api      │
                    │ (Tier 2)        │
                    └────────┬────────┘
                             │
┌─────────────────┐          │         ┌─────────────────┐
│ checkout-service│          │         │ admin-dashboard │
│ (Tier 1)        │──────────┼────────▶│ (Tier 3)        │
└────────┬────────┘          │         └─────────────────┘
         │                   │
         ▼                   ▼
┌─────────────────────────────────────┐
│         payments-service            │
│         (Tier 1) ⚠️                 │
└─────────────────────────────────────┘
         │
         ▼
┌─────────────────┐
│ payment-processor│
│ (External)       │
└─────────────────┘
```

### Impact Summary

| Service | Tier | Impact | Users Affected |
|---------|------|--------|----------------|
| checkout-service | 1 | **Critical** — Cannot complete purchases | All customers |
| mobile-api | 2 | **High** — Mobile checkout broken | Mobile users |
| admin-dashboard | 3 | **Low** — Payment reports unavailable | Internal only |

### Estimated Impact
- **Revenue:** ~$50K/hour during peak
- **Users:** 100% of checkout flow
- **SLA Risk:** Yes — Tier 1 service

### Recommendation
payments-service is critical path for revenue. Any incident should be treated as SEV1 regardless of initial severity.

---

## Example 4: Drafting an Incident Update

**User:** Draft a status update for incident INC-042

**Agent:**

## Incident Update: INC-042

**Status:** Investigating → Identified
**Time:** 2024-01-15 14:30 UTC

### Summary
We've identified the likely cause of elevated latency in the payments service.

### What We Know
- Latency increased ~45 minutes ago following a deployment (v2.3.1)
- The deployment added retry logic that appears to cause cascading delays under load
- No data loss or failed transactions — requests are completing, just slowly

### Current Impact
- Payment processing taking 3-5 seconds instead of <1 second
- Checkout completion rate down ~15%
- No customer-facing errors

### Next Steps
- Rolling back to v2.3.0 (ETA: 5 minutes)
- Will monitor for 15 minutes post-rollback
- Next update in 20 minutes or when resolved

### Team
- Incident Commander: alice@acme.com
- Investigating: alice@acme.com, bob@acme.com

---

*Copy this to your #incidents Slack channel or status page.*

---

## Example 5: Decision Support

**User:** Should I rollback checkout-service?

**Agent:**

## Rollback Analysis: checkout-service

### Current State
- **Version:** v1.8.1 (deployed 6h ago)
- **Previous:** v1.8.0
- **Open Incidents:** None
- **Error Rate:** Normal (0.1%)
- **Latency:** Normal (p99: 120ms)

### What Changed in v1.8.1
- Cart calculation fix for discount codes
- 45 lines changed in `cart/calculator.go`
- Passed all tests, reviewed by dave@acme.com

### Rollback Assessment

| Factor | Assessment |
|--------|------------|
| Current health | ✅ Healthy — no issues detected |
| Change risk | ✅ Low — small, tested change |
| Time since deploy | ⚠️ 6 hours — would have seen issues by now |
| Business impact | ⚠️ Rolling back re-introduces discount bug |

### Recommendation: **Don't rollback**

There's no indication of problems with v1.8.1. The service is healthy, and rolling back would re-introduce the cart calculation bug that v1.8.1 fixed.

If you're seeing an issue I'm not aware of, please share the symptoms and I'll re-analyze.

---

## Tips for Effective Prompts

1. **Be specific** — "Investigate INC-042" beats "help me with an incident"
2. **Name entities** — Use service names and incident IDs
3. **State your goal** — "I need to decide whether to rollback"
4. **Ask follow-ups** — The agent remembers context within a conversation
