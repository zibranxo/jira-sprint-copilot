# Ownership and Sprint Evaluation Policy

This policy defines the scoring algorithms, decision rules, and approval gates enforced by Jira Sprint Copilot when recommending assignees, shaping sprint scope, balancing team workload, or assessing delivery risks.

---

## 1. Candidate Ownership Scoring Model

When an unassigned ticket is triaged or workload is rebalanced, candidate assignees are evaluated against weighted scoring criteria. The score indicates match confidence and does not grant automatic permission to mutate Jira.

### Positive Match Signals

| Signal | Weight | Description |
| :--- | :--- | :--- |
| Component Match | `+4` | Candidate is listed as primary owner for the Jira component |
| Label / Domain Match | `+3` | Candidate matches feature area or domain label specified on the ticket |
| Skill Match | `+3` | Candidate holds technical proficiencies matching ticket requirements |
| Recent Domain Activity | `+2` | Candidate completed similar tickets within the preceding two sprints |
| Contextual Activity | `+2` | Active watcher, reviewer, PR author, or branch contributor on related work |
| Designated Backup | `+1` | Candidate is listed as designated backup for the primary component owner |

### Negative Penalty Signals

| Signal | Weight | Description |
| :--- | :--- | :--- |
| Not in Allowlist | `-5` | Candidate is not marked as `assignment_allowlist: true` |
| Window Unavailability | `-4` | Candidate is on approved PTO or unavailable during the sprint window |
| WIP Limit Reached | `-4` | Candidate currently equals or exceeds their `max_in_progress` threshold |
| Capacity Exceeded | `-3` | Ticket point estimate would push candidate over `sprint_capacity_points` |
| Cross-Team Boundary | `-3` | Assignment crosses teams without an explicit cross-team routing rule |
| Hard Blocker Inability | `-2` | Ticket is blocked by external dependencies outside candidate's control |
| Incomplete Acceptance | `-2` | Ticket lacks explicit acceptance criteria or has an ambiguous description |

### Confidence Classification

```text
Score >= 6 (and no hard blocker)  --> HIGH CONFIDENCE
Score 3 to 5 (or one soft risk)   --> MEDIUM CONFIDENCE
Score < 3 (or policy conflict)    --> LOW CONFIDENCE
```

- **High Confidence**: Recommended for assignment upon standard human confirmation.
- **Medium Confidence**: Viable recommendation, but surfaces clear caveats or alternative candidates.
- **Low Confidence**: Flagged as requiring manual team lead review before any assignment is attempted.

---

## 2. Sprint Readiness Scoring Model

Used by `shape-sprint` and `triage-queue` to determine if backlog items are fit to enter active sprint execution.

### Readiness Boosters

| Factor | Weight | Evaluation Criteria |
| :--- | :--- | :--- |
| High Strategic Priority | `+4` | Marked Blocker/Critical priority or mapped to key milestone |
| Confirmed Assignment | `+3` | Assigned to a medium or high confidence owner within capacity |
| Concrete Specifications | `+2` | Clear acceptance criteria and definition of done documented |
| Dependency Clearance | `+2` | External and internal ticket dependencies are already resolved |
| Customer / Field Escalation | `+1` | Verified defect or active customer escalation requirement |

### Readiness Blockers

| Factor | Weight | Evaluation Criteria |
| :--- | :--- | :--- |
| Active Dependency Blocker | `-5` | Linked upstream dependency remains open or in progress |
| No Available Owner | `-4` | No allowlisted engineer with capacity and matching skills exists |
| Vague Scope | `-3` | Missing user story, missing description, or unquantifiable scope |
| Unverified Technical Path | `-3` | Architectural or security clearance label present without sign-off |
| Oversized for Window | `-2` | Story point estimate exceeds individual or sprint remaining capacity |

---

## 3. Human-in-the-Loop Approval Checkpoint

All mutations that alter ticket ownership in Jira must pass through a strict verification checkpoint:

```text
[AI Analysis & Candidate Scoring]
               │
               ▼
[Confidence Level & Capacity Checked]
               │
               ▼
       Is --apply passed?
       ├── NO  ──> Emit "PENDING APPROVAL" (Dry-Run / Report Only)
       └── YES ──> Is --approved-by an authorized authority in team-map?
                     ├── NO  ──> Reject execution, abort mutation
                     └── YES ──> Verify Confidence >= Medium
                                   ├── PASS ──> Apply Jira mutation & write audit log
                                   └── FAIL ──> Halt; require explicit issue-to-owner override
```

### Safety Principles

1. **Dry-Run by Default**: Unless `--apply` is explicitly passed, every run produces recommendations only.
2. **Authorized Sign-off**: Any mutation modifying assignees requires `--approved-by` matching an entry in `approval.assigning_authorities`.
3. **Hard Blocker Guard**: Even with approval flags present, low-confidence assignments or items with hard blockers remain un-applied unless the approver explicitly specifies both the target ticket and owner.
4. **Audit Trail**: Every applied change generates a machine-readable entry in `automation/output/approvals.log`.

---

## 4. Operational Artifact Formats

### Format: Pending Approval Item (Dry-Run / Unapproved)

```text
PENDING APPROVAL: ENG-412
Current Owner: unassigned
Proposed Owner: alex.rivera@example.com
Confidence: HIGH (Score: +7)
Rationale: Primary API Gateway component owner, matching backend skill, available WIP (1/3)
Identified Risks: None
Authority Required: Alex Rivera or Engineering Manager
```

### Format: Executed Approval Record (Apply Mode)

```text
APPROVED: ENG-412
Approved By: Alex Rivera
Applied Change: Assignee updated to alex.rivera@example.com
Rationale: High component ownership and available sprint point capacity
Logged At: 2026-11-17T03:30:00Z
```
