# Jira Query Guide

This guide provides tested, high-performance JQL (Jira Query Language) patterns utilized by Jira Sprint Copilot across its operational workflows.

---

## Standard JQL Query Patterns

Replace `ENG, CORE` with your designated project keys, and customize custom fields or labels as appropriate for your Jira instance.

### 1. Active Sprint Workload
Fetches all open and in-flight issues in the currently active sprint, ordered by backlog rank.
```text
project in (ENG, CORE) AND sprint in openSprints() ORDER BY Rank ASC
```

### 2. Backlog Triage & Grooming Slice
Surfaces unassigned or unstarted work outside active sprints, prioritized by urgency and age.
```text
project in (ENG, CORE) AND statusCategory != Done AND sprint is EMPTY ORDER BY priority DESC, created ASC
```

### 3. Queue Triage & Attention Needed
Identifies backlog items prioritized by recent update activity to catch forgotten requests.
```text
project in (ENG, CORE) AND statusCategory != Done AND sprint is EMPTY ORDER BY priority DESC, updated ASC
```

### 4. Unassigned Work Discovery
Locates unassigned issues across active workflows needing owner suggestions.
```text
project in (ENG, CORE) AND assignee is EMPTY AND statusCategory != Done ORDER BY priority DESC, updated ASC
```

### 5. Stale Work Detection
Surfaces tickets in active or open states that have seen no status or comment updates for 3 or more days.
```text
project in (ENG, CORE) AND statusCategory != Done AND updated <= -3d ORDER BY updated ASC
```

### 6. Delivery Risk Analysis Slice
Pinpoints tickets with high probability of missing commitments: unassigned work, stale tickets, or work stuck in review or testing gates.
```text
project in (ENG, CORE) AND statusCategory != Done AND (assignee is EMPTY OR updated <= -3d OR status in ("Blocked", "On Hold", "In Review", "Testing")) ORDER BY priority DESC, updated ASC
```

### 7. Workload Balancing Inspection
Retrieves active sprint issues grouped by assignee to detect distribution skew and capacity overload.
```text
project in (ENG, CORE) AND sprint in openSprints() AND statusCategory != Done ORDER BY assignee ASC, priority DESC
```

### 8. Daily Standup Pulse (Last 24 Hours)
Isolates tickets modified during the previous working day to identify completed items and fresh blockers.
```text
project in (ENG, CORE) AND sprint in openSprints() AND updated >= -1d ORDER BY updated DESC
```

### 9. Sprint Retrospective Slice
Collects all issues associated with recently closed sprints to analyze completion rates, spillover, and lead times.
```text
project in (ENG, CORE) AND sprint in closedSprints() ORDER BY updated DESC
```

---

## Field Retrieval Recommendations

To preserve token context and optimize query latency, request only essential fields when interacting via Jira MCP tools:

```text
summary, status, assignee, priority, components, labels, updated, created, duedate
```

> [!TIP]
> Only query `*all` fields when investigating custom Jira fields (such as Story Points or Acceptance Criteria custom field IDs) whose keys are not known in advance.
