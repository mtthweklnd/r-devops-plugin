---
name: azure-devops-mcp
description: Query and mutate Azure DevOps work items, inspect repositories and pull requests, and trigger or check pipeline runs using the @azure-devops/mcp server. Use when interacting with Azure DevOps via MCP tools, debugging connection/auth issues, or constructing work item mutations.
metadata:
  version: "1.1"
---

# Azure DevOps MCP Agent Guide

Standard operating procedure for agents interacting with Azure DevOps resources via the `@azure-devops/mcp` stdio server.

---

## 1. Pre-Flight Verification

Before invoking any Azure DevOps MCP tool, verify the runtime environment:

1. **Authentication Mode**: Verify client is configured with `-a pat` (Stdio transport).
2. **Environment Variables**:
   - `AZURE_DEVOPS_ORG`: Target organization name (slug from `dev.azure.com/<org>`).
   - `PERSONAL_ACCESS_TOKEN` / `AZURE_DEVOPS_PAT`: Must be **base64-encoded `:{raw_pat}`**.
3. **Connection Sanity Check**:
   - Run `core_list_projects` first to verify authentication and connectivity.
   - If `read ECONNRESET` occurs, ensure `NODE_OPTIONS="--dns-result-order=ipv4first"` is active in the environment.

---

## 2. Tool Directory & Namespace

In Claude Code and agent runtimes, tools are surfaced under the plugin namespace:
`mcp__plugin_r-posit-devops-plugin_azure-devops__<tool_name>` or `<tool_name>`.

| Domain | Key Tools | Typical Agent Use |
| :--- | :--- | :--- |
| **Core** | `core_list_projects`, `core_list_project_teams` | Workspace discovery & project GUID lookup |
| **Work Items** | `wit_work_item`, `wit_work_item_write`, `wit_query_by_wiql` | Backlog triage, task creation, status updates |
| **Repos & PRs** | `git_list_repositories`, `git_get_pull_requests` | Branch verification, PR review assistance |
| **Pipelines** | `pipelines_list_pipelines`, `pipelines_get_run` | CI/CD status inspection, failure log extraction |

---

## 3. Work Item Operations (`wit_work_item_write`)

### Critical Constraints
- **Strict field names**: Always use canonical field reference IDs (e.g. `System.Title`, NOT `Title`).
- **Markdown formatting**: Always include `"format": "Markdown"` when populating `System.Description` or `Microsoft.VSTS.Common.AcceptanceCriteria`.
- **Atomic updates**: Use `update` with field patches rather than recreating work items.

### Action Payloads

#### A. Create Task
```json
{
  "action": "create",
  "project": "<project-name>",
  "workItemType": "Task",
  "fields": [
    { "name": "System.Title", "value": "Brief imperative title" },
    { "name": "System.Description", "value": "Detailed markdown explanation.", "format": "Markdown" },
    { "name": "System.AssignedTo", "value": "user@example.com" }
  ]
}
```

#### B. Create User Story with Acceptance Criteria
```json
{
  "action": "create",
  "project": "<project-name>",
  "workItemType": "User Story",
  "fields": [
    { "name": "System.Title", "value": "As a <role>, I want <capability>" },
    { "name": "System.Description", "value": "Story context and user motivation.", "format": "Markdown" },
    { "name": "Microsoft.VSTS.Common.AcceptanceCriteria", "value": "1. Scenario A passes\n2. Edge case B handled", "format": "Markdown" }
  ]
}
```

#### C. Update Status or Field on Existing Work Item
```json
{
  "action": "update",
  "id": 1234,
  "project": "<project-name>",
  "updates": [
    { "name": "System.State", "value": "Active" },
    { "name": "System.History", "value": "Automated update from AI pair programmer." }
  ]
}
```

#### D. Link Child Item to Parent
```json
{
  "action": "add_child",
  "project": "<project-name>",
  "parentId": 1234,
  "workItemType": "Task",
  "items": [
    {
      "fields": [
        { "name": "System.Title", "value": "Subtask title" },
        { "name": "System.Description", "value": "Subtask details", "format": "Markdown" }
      ]
    }
  ]
}
```

---

## 4. Querying Work Items via WIQL (`wit_query_by_wiql`)

Use Work Item Query Language (WIQL) for targeted batch retrieval.

```sql
SELECT [System.Id], [System.Title], [System.State], [System.AssignedTo]
FROM workitems
WHERE [System.TeamProject] = @project
  AND [System.WorkItemType] = 'Task'
  AND [System.State] NOT IN ('Closed', 'Done', 'Removed')
ORDER BY [System.ChangedDate] DESC
```

---

## 5. Canonical Field Reference Map

| Conceptual Name | Canonical Reference ID | Applies To |
| :--- | :--- | :--- |
| Title | `System.Title` | All work items (Required) |
| Description | `System.Description` | All work items |
| Status / State | `System.State` | All work items |
| Assigned User | `System.AssignedTo` | All work items |
| Area Path | `System.AreaPath` | All work items |
| Iteration / Sprint | `System.IterationPath` | All work items |
| Acceptance Criteria | `Microsoft.VSTS.Common.AcceptanceCriteria` | User Story, Bug |
| Discussion / History | `System.History` | Append-only comments |
| Story Points | `Microsoft.VSTS.Scheduling.StoryPoints` | Agile User Story |
| Remaining Work (hrs)| `Microsoft.VSTS.Scheduling.RemainingWork` | Tasks |

To query project-specific custom fields:
```bash
curl -s -u ":$RAW_PAT" "https://dev.azure.com/{org}/{project}/_apis/wit/workitemtypes/{type}/fields?api-version=7.1" | jq '.value[] | {name: .name, referenceName: .referenceName}'
```

---

## 6. Failure Recovery & Troubleshooting

| Error / Symptom | Root Cause | Exact Resolution |
| :--- | :--- | :--- |
| `read ECONNRESET` | Node IPv6 resolution timeout | Set `NODE_OPTIONS="--dns-result-order=ipv4first"` |
| `401 Unauthorized` / `Invalid token` | Token base64-encoded without email prefix | Regenerate: `printf '%s:%s' "$EMAIL" "$RAW_PAT" \| base64` |
| `Field 'X' not found` | Using UI display name instead of Reference ID | Replace with canonical reference ID from Section 5 |
| Hanging process / No response | Client timeout or interactive npm prompt | Use `-y` flag with `npx`, or install globally via `npm i -g @azure-devops/mcp` |
| `Cannot read properties of undefined` | Missing required payload argument | Ensure `project`, `workItemType`, and `fields` array are present |

---

## 7. Configuration Reference

### Terminal / Claude Code (`.mcp.json`)
```json
{
  "azure-devops": {
    "command": "npx",
    "args": ["-y", "@azure-devops/mcp", "${AZURE_DEVOPS_ORG}", "-a", "pat"],
    "env": {
      "PERSONAL_ACCESS_TOKEN": "${AZURE_DEVOPS_PAT}",
      "NODE_OPTIONS": "--dns-result-order=ipv4first"
    }
  }
}
```

### Environment Export
```bash
export AZURE_DEVOPS_ORG="<org-slug>"
export AZURE_DEVOPS_PAT=$(printf ':%s' "<raw-pat-value>" | base64)
```
