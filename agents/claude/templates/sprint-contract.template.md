> Copy this file to `.claude-sprints/<sprint-id>.md` in your project directory before implementation begins.

# Sprint Contract: {{sprint_name}}

This template is a 1-sprint = 1-feature contract. The Planner drafts it, Generator and Evaluator sign off, and the Definition of Done is locked before implementation starts.

## Metadata
- **Sprint ID**: {{e.g. SP-001}}
- **Created**: {{YYYY-MM-DD}}
- **Owner (Generator)**: {{engineer agent name}}
- **Reviewer (Evaluator)**: {{reviewer agent name}}
- **Parent Spec**: {{path to product spec, or 'N/A'}}
- **Related Handoff**: {{path to .claude-handoff.md if created, else 'none'}}

## Goal
{{Describe the user-facing value this sprint delivers. What changes? Why does it matter?}}

## Scope

### In-Scope
- [ ] {{feature / file / behavior to implement}}
- [ ] {{another item}}

### Out-of-Scope
- [ ] {{explicitly excluded item — what will NOT be done}}
- [ ] {{another exclusion}}

## Definition of Done
Write only measurable criteria (each must be PASS/FAIL decidable).
- [ ] {{criterion}}
- [ ] {{criterion}}
- [ ] {{criterion}}

## Verification Plan

### API
- [ ] {{Run: curl/httpie command}} -> Expected: {{response shape}}
- [ ] {{Another API check}}

### UI
- [ ] {{Playwright/browser step}} -> Visual check: {{what to observe}}
- [ ] {{Another UI check}}

### DB
- [ ] {{Query to verify schema/data integrity}} -> Expected state: {{before/after}}
- [ ] {{Another DB check}}

## Acceptance Criteria
Focus on quality and non-functional requirements (do not duplicate Definition of Done).
- [ ] Performance: {{e.g. p95 response time < 500ms under 100 concurrent users}}
- [ ] Security: {{e.g. all user inputs validated and sanitized}}
- [ ] Test coverage: {{e.g. >= 80% line coverage on new code}}
- [ ] Documentation: {{e.g. API endpoints documented in README}}

## Risks & Assumptions

### Risks
- {{Risk description}} -> Mitigation: {{mitigation strategy}}

### Assumptions
- {{Assumption the implementation depends on}}

## Sign-off
- [ ] Planner: {{name}} — {{date}}
- [ ] Generator: {{name}} — {{date}}
- [ ] Evaluator: {{name}} — {{date}}

## Reference Example
Example sprint: "Add search filter to Todo list API"

### Metadata
- **Sprint ID**: SP-007
- **Created**: 2025-02-14
- **Owner (Generator)**: Codex Backend Engineer
- **Reviewer (Evaluator)**: SQLite Reviewer
- **Parent Spec**: specs/todo-search-filter.md
- **Related Handoff**: none

### Goal
Add keyword search to `GET /api/todos` so users can filter the returned list by title substring. This improves findability in longer todo lists without requiring a separate search screen or a new endpoint.

### Scope

#### In-Scope
- [ ] Add optional `q` query parameter to `GET /api/todos`.
- [ ] Apply a case-insensitive `LIKE` filter against todo titles when `q` is provided.
- [ ] Update the OpenAPI spec and endpoint examples to document the new filter behavior.

#### Out-of-Scope
- [ ] Full-text search indexing or ranking.
- [ ] Saved searches or persistent search preferences.
- [ ] Search history, analytics, or UI redesign beyond exposing the filter in the existing list view.

### Definition of Done
Write only measurable criteria (each must be PASS/FAIL decidable).
- [ ] `GET /api/todos` returns the same response shape as before when `q` is omitted.
- [ ] `GET /api/todos?q=milk` returns only todos whose `title` contains `milk`, regardless of case.
- [ ] Query parameter handling uses bound parameters so input such as `' OR 1=1 --` does not alter SQL behavior or expand result sets.
- [ ] OpenAPI documentation includes the `q` parameter, its behavior, and at least one filtered response example.

### Verification Plan

#### API
- [ ] Run: `curl -s "http://localhost:3000/api/todos?q=milk"` -> Expected: JSON array where every item includes `title` containing `milk` or `Milk`, for example `[{"id":12,"title":"Buy milk","completed":false}]`.
- [ ] Run: `curl -s "http://localhost:3000/api/todos?q=%27%20OR%201%3D1%20--"` -> Expected: HTTP 200 with either an empty array or only literal substring matches; response count must not jump to all rows.

#### UI
- [ ] In Playwright, open the Todo list page, type `milk` into the search field wired to `GET /api/todos?q=milk`, and confirm only matching rows remain visible. Visual check: non-matching todos disappear and the list layout remains stable.
- [ ] Clear the search field and confirm the full list returns. Visual check: the item count matches the pre-search state and no error banner appears.

#### DB
- [ ] Run: `SELECT id, title FROM todos WHERE lower(title) LIKE lower('%milk%');` -> Expected state: result set matches the API payload for `q=milk`.
- [ ] Run: `EXPLAIN QUERY PLAN SELECT id, title FROM todos WHERE lower(title) LIKE lower('%milk%');` -> Expected state: query plan is valid and completes without schema errors before and after the change.

### Acceptance Criteria
Focus on quality and non-functional requirements (do not duplicate Definition of Done).
- [ ] Performance: p95 response time for `GET /api/todos?q=<term>` stays below 500 ms with 100 concurrent users on the staging dataset.
- [ ] Security: all search input is validated as text and passed through parameterized queries, with regression coverage for SQL injection attempts.
- [ ] Test coverage: new or changed backend search logic has at least 80% line coverage.
- [ ] Documentation: README or API docs show the `q` parameter, an example request, and expected filtered response behavior.

### Risks & Assumptions

#### Risks
- SQLite `LIKE` scans may slow down on large datasets without a supporting index or search strategy -> Mitigation: measure query time on the staging dataset now; if p95 exceeds target, raise a follow-up sprint for indexing or FTS instead of expanding this sprint.

#### Assumptions
- The existing automated test suite passes before this sprint starts, so any failures during this sprint can be attributed to the new search work.

### Sign-off
- [ ] Planner: Alex Planner — 2025-02-14
- [ ] Generator: Sam Generator — 2025-02-14
- [ ] Evaluator: Riley Evaluator — 2025-02-14
