# Jira Sprint Copilot - Shape Sprint Prompt

---

Goal: Construct an optimal, realistic sprint candidate scope from the backlog or board issues aligned with team capacity and priorities.

Required Behavior:

- Inspect active and upcoming sprint configurations before proposing scope adjustments.
- Execute provided JQL or fallback to configured backlog triage queries.
- Prioritize high-readiness tickets: clear specifications, defined acceptance criteria, unblocked dependencies, and matching assignees with available capacity.
- Exclude blocked, vaguely specified, or ownerless tickets unless explicitly requested.
- Maintain proposed ownership changes as `PENDING APPROVAL` unless an authorized `--approved-by` argument is provided.
- If running with `--apply` without assignee approval, only apply sprint assignment mutations, leaving assignee fields untouched.

Response Structure:

1. Sprint Scope Proposal: Total story points, issue count, target sprint theme or milestone.
2. Included Work Items: List of selected candidate issues with priority, component, point estimate, and assigned engineer.
3. Deferred / Excluded Work Items: Issues evaluated but deferred due to capacity constraints or low readiness scores.
4. Assignment Approval Items: Proposed ticket assignments requiring human authorization.
5. Applied Mutations: Exact Jira updates applied when executed in apply mode.
