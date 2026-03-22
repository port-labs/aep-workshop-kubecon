# MCP Server Setup Guide

How to connect external tools to Port AI agents via MCP.

## Overview

MCP (Model Context Protocol) is an open standard for connecting AI models to external tools and data sources. Port supports MCP servers, allowing agents to query external systems during conversations.

## Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Port Agent │────▶│  MCP Proxy  │────▶│  Datadog    │
│             │     │  (optional) │     │  GitHub     │
│             │     │             │     │  PagerDuty  │
└─────────────┘     └─────────────┘     └─────────────┘
```

### Option A: Direct Connection
Port connects directly to an MCP-compatible server.

### Option B: MCP Proxy
A proxy service that:
- Handles authentication
- Transforms requests
- Caches responses
- Enforces rate limits

## Setting Up an MCP Server in Port

### Step 1: Register the Server

In Port UI:
1. Go to Settings → MCP Servers
2. Click "Add MCP Server"
3. Fill in:
   - **Name:** Datadog
   - **URL:** https://your-mcp-proxy.com/datadog
   - **Authentication:** Bearer token or API key

Or via API:
```bash
curl -X POST "https://api.getport.io/v1/mcp-servers" \
  -H "Authorization: Bearer $PORT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "identifier": "datadog_mcp",
    "title": "Datadog",
    "url": "https://your-mcp-proxy.com/datadog",
    "headers": {
      "Authorization": "Bearer {{secrets.DATADOG_API_KEY}}"
    }
  }'
```

### Step 2: Configure Allowed Tools

Define which tools the agent can use:

```json
{
  "allowed_tools": [
    "search_logs",
    "get_metrics",
    "get_monitors"
  ]
}
```

### Step 3: Store Secrets

Store API keys securely:
1. Go to Settings → Secrets
2. Add secret: `DATADOG_API_KEY`
3. Reference in MCP config: `{{secrets.DATADOG_API_KEY}}`

### Step 4: Test the Connection

Use the Port UI to test:
1. Go to the MCP server settings
2. Click "Test Connection"
3. Try a sample tool call

## Building an MCP Proxy

If you need to connect to services that don't have native MCP support, build a proxy.

### Example: Express.js Proxy

```javascript
const express = require('express');
const app = express();

// Datadog proxy
app.post('/datadog/search_logs', async (req, res) => {
  const { service, query, timeframe } = req.body;
  
  // Transform to Datadog API call
  const response = await fetch('https://api.datadoghq.com/api/v2/logs/events/search', {
    method: 'POST',
    headers: {
      'DD-API-KEY': process.env.DD_API_KEY,
      'DD-APPLICATION-KEY': process.env.DD_APP_KEY,
    },
    body: JSON.stringify({
      filter: {
        query: `service:${service} ${query}`,
        from: timeframeToTimestamp(timeframe),
        to: 'now',
      },
    }),
  });
  
  const data = await response.json();
  
  // Transform response for agent consumption
  res.json({
    logs: data.data.map(log => ({
      timestamp: log.attributes.timestamp,
      message: log.attributes.message,
      status: log.attributes.status,
    })),
  });
});

app.listen(3000);
```

### MCP Response Format

Responses should be structured for agent consumption:

```json
{
  "success": true,
  "data": {
    "logs": [
      {
        "timestamp": "2024-01-15T14:30:00Z",
        "message": "Connection timeout to payment processor",
        "status": "error",
        "service": "payments"
      }
    ]
  },
  "metadata": {
    "total_count": 150,
    "returned_count": 100,
    "timeframe": "1h"
  }
}
```

## Security Best Practices

### 1. Least Privilege
Only expose tools the agent actually needs.

```json
{
  "allowed_tools": ["search_logs", "get_metrics"],
  "denied_tools": ["delete_logs", "modify_dashboards"]
}
```

### 2. Read-Only by Default
Agents should query, not modify. Reserve write operations for human-triggered actions.

### 3. Rate Limiting
Prevent runaway queries:

```json
{
  "rate_limit": {
    "requests_per_minute": 30,
    "burst": 10
  }
}
```

### 4. Audit Logging
All MCP calls are logged in Port. Review regularly.

### 5. Scoped Tokens
Use tokens with minimal scope:
- Datadog: `logs_read`, `metrics_read` only
- GitHub: `repo:read` only
- PagerDuty: Read-only API key

## Troubleshooting

### "Tool not found"
- Check tool name matches exactly
- Verify tool is in `allowed_tools` list

### "Authentication failed"
- Verify secret is stored correctly
- Check secret reference syntax: `{{secrets.NAME}}`
- Ensure token has required scopes

### "Rate limit exceeded"
- Increase rate limits if appropriate
- Add caching to your proxy
- Optimize agent prompts to reduce calls

### "Timeout"
- Increase timeout settings
- Add pagination for large queries
- Check external service health

## Example: Full Investigation Flow

Agent receives: "Why is payments slow?"

1. **Query Port catalog**
   - Get service details
   - Find recent deployments

2. **Query Datadog MCP**
   ```
   search_logs(service='payments', query='status:error', timeframe='1h')
   get_metrics(metric='latency.p99', service='payments', timeframe='1h')
   ```

3. **Query GitHub MCP**
   ```
   compare_commits(repo='acme/payments', base='v2.3.0', head='v2.3.1')
   ```

4. **Synthesize**
   - Correlate deployment time with latency spike
   - Identify error pattern in logs
   - Find relevant code change

5. **Respond**
   > "Latency spiked at 14:15 UTC, 15 minutes after v2.3.1 deployed. 
   > Logs show 'connection timeout' errors. The v2.3.1 commit added 
   > retry logic that appears to exhaust the connection pool. 
   > Recommend rollback to v2.3.0."
