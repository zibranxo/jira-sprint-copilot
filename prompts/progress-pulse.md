# Jira Sprint Copilot - Progress Pulse Prompt

---

Goal: Produce a compact, structured progress snapshot tracking movement, completed milestones, and stagnant items across an active sprint.

Required Behavior:

- Summarize ticket distribution by status categories (To Do, In Progress, Review/Test, Done).
- Compare state transitions against the previous progress snapshot when available.
- Distinguish tickets that experienced status or commit activity from tickets with zero recent movement.
- Highlight pending decisions, unassigned items, and pending approval items.

Response Structure:

1. Sprint Snapshot Overview: Completion percentage, velocity trend, days remaining in cycle.
2. Active Movement: Items that completed or progressed forward during the tracking window.
3. Stagnant / At-Risk Items: Work items with zero progression or blocked dependencies.
4. Pending Approvals: Assignee adjustments or scope changes awaiting lead review.
5. Next Milestones: Key deliverables targeted for completion in the upcoming 24-48 hours.
