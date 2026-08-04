> Copy this file to .claude-handoff.md in your project root when a context reset or agent handoff is needed.

# Handoff: {{task_name}}

This document enables the next session or agent to cold-start and continue.
It locks current state, decision log, next steps, and acceptance status into a structured artifact.

## Metadata
- **Task ID**: {{e.g. HO-001 or Sprint ID such as SP-007}}
- **Handoff Date**: {{YYYY-MM-DD HH:MM}}
- **Outgoing Agent**: {{name / session_id}}
- **Incoming Agent**: {{name if known, else 'TBD'}}
- **Related Sprint Contract**: {{path to .claude-sprints/<sprint-id>.md, or 'N/A'}}

## Current State
{{One paragraph describing the overall picture: repo, branch, last commit, and any running processes.}}

- Working directory: {{path}}
- Git HEAD: {{commit sha and message}}
- Environment notes: {{key runtime facts, e.g. venv activated, DB migrated to version X}}

## Completed
- [x] {{what was done}} — {{file path or commit sha}}
- [x] {{another item}} — {{location}}

## In Progress
- {{Item currently WIP}} — stopped at: {{where exactly}}
- Uncommitted changes summary: {{paste git diff --stat output or 'none'}}

## Next Steps (Prioritized)
- [P0] {{Immediate action — must do first}}
- [P1] {{Next action}}
- [P2] {{Lower priority action}}

## Decision Log
| Date | Decision | Rationale | Reversibility |
| --- | --- | --- | --- |
| {{YYYY-MM-DD}} | {{decision made}} | {{why}} | {{easy / hard / irreversible}} |
| | | | |

## Open Risks
- {{Risk description}} — Tentative mitigation: {{approach}}

## Assumptions
- {{Assumption the next agent can treat as given}}
- **{{Load-bearing assumption — if wrong, Next Steps change}}**

## Acceptance Status
Current progress against Sprint Contract Definition of Done:
- Definition of Done: {{X}}/{{Y}} complete
- [x] {{completed criterion}}
- [ ] {{remaining criterion — reason if blocked}}

## Reference Example
A fully filled-in example consistent with the Sprint Contract example (same Todo list API search feature, SP-007, mid-implementation):

- Task ID: SP-007
- Handoff Date: 2026-04-15 14:30
- Outgoing Agent: engineer@harness-upgrade / session abc123
- Incoming Agent: TBD
- Related Sprint Contract: .claude-sprints/SP-007.md

### Current State
The repo is on `main` with the search-filter sprint in progress. The last commit is `feat: add ?q= param to GET /api/todos`. `pytest` is currently passing on the branch, the local SQLite schema has already been migrated for this sprint, and no long-running background process is required beyond the usual app server started by the next agent if needed.

- Working directory: `/workspace/todo-api`
- Git HEAD: `8f3c2a1 feat: add ?q= param to GET /api/todos`
- Environment notes: Python venv activated, SQLite DB migrated to latest local schema, `pytest` green before the current WIP test edits

### Completed
- [x] Added optional `q` query parameter handling to `GET /api/todos` — `app/routes/todos.py`
- [x] Implemented case-insensitive title filtering with bound parameters — `app/db/todo_queries.py`
- [x] Added baseline API tests for matching and non-matching queries — `tests/test_todos.py`

### In Progress
- Integration test for empty query string behavior — stopped at: `tests/test_todos.py:87`
- Uncommitted changes summary: `tests/test_todos.py | 14 ++++++++++----`

### Next Steps (Prioritized)
- [P0] Finish the empty-query integration test and make expected behavior explicit
- [P1] Update the OpenAPI spec and example request/response for `q`
- [P2] Add rate limiting coverage for repeated search requests

### Decision Log
| Date | Decision | Rationale | Reversibility |
| --- | --- | --- | --- |
| 2026-04-15 | Use `LIKE` with `lower(title)` instead of SQLite FTS | Keeps the sprint scoped to a small API change without schema expansion | easy |
| 2026-04-15 | Keep search on the existing `GET /api/todos` endpoint via optional `q` | Avoids adding a second endpoint for a simple filter use case | easy |
| 2026-04-15 | Treat empty `q` as equivalent to no filter | Prevents surprising zero-result behavior for blank UI submissions | easy |

### Open Risks
- SQLite `LIKE` performance may degrade on larger datasets — Tentative mitigation: measure query latency on the staging dataset and spin out indexing or FTS as a follow-up if needed

### Assumptions
- The test database is seeded with 100 todo rows that include enough title variation to validate substring search behavior
- **Search remains substring-only for this sprint; if ranking or tokenization is required, Next Steps must shift toward FTS work**

### Acceptance Status
Current progress against Sprint Contract Definition of Done:
- Definition of Done: 4/7 complete
- [x] `GET /api/todos` returns the same response shape as before when `q` is omitted
- [x] `GET /api/todos?q=milk` returns only todos whose `title` contains `milk`, regardless of case
- [x] Query parameter handling uses bound parameters so SQL injection attempts do not alter result sets
- [x] Baseline automated tests cover matching and non-matching search behavior
- [ ] Empty-string search behavior is fully specified and tested — blocked until the in-progress integration test is finished
- [ ] OpenAPI documentation includes the `q` parameter and filtered response example — not started
- [ ] Rate limiting coverage is in place for repeated search requests — not started
