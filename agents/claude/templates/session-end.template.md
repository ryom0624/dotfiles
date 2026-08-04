> Copy this file to `.claude-session-end.md` in your project root. Run through it before ending every session.

# Session End Checklist: {{project_name}}

This checklist exists so every session ends with a clean repo, an honest progress record, and a smooth pickup point for the next agent or session.

## When to Use
- Before ending any session that touched code, templates, or feature state
- Before a planned context reset (must complete before resetting)
- Before passing work to another agent (must complete before handoff)

## Time Budget
- Target: complete in **10 minutes or less**
- If a step uncovers blocking issues, finish the rest of the checklist anyway and capture the issue in `.claude-handoff.md`

## Checklist

### 1. Working Tree State
- [ ] Run `git status --short` → review every modified, added, or deleted file
- [ ] Confirm no accidental changes (e.g., editor swap files, stray logs, secrets)
- [ ] Run `git diff --stat` → confirm change footprint matches the session intent

### 2. Update Feature Status
- [ ] For each feature finished this session, update `.claude-features.json`:
  - `status`: `in_progress` → `passed` only when ALL `verification_steps` produced expected output
  - `updated_at`: today (`YYYY-MM-DD`)
- [ ] For features that started but did not finish: keep `status` at `in_progress`, append a note describing the stopping point
- [ ] Do NOT delete or renumber feature IDs (immutable per `_editing_policy`)

### 3. Re-run Smoke
- [ ] Execute `./init.sh` → wait for `init.sh OK` line
- [ ] If smoke now fails after passing at session start: STOP, do not commit, capture the regression first
- [ ] Confirm health endpoint, DB smoke, and env vars still pass

### 4. Commit
- [ ] Stage intentional changes only (`git add -p` preferred)
- [ ] Commit with conventional message style (e.g., `feat: ...`, `fix: ...`, `docs: ...`)
- [ ] Reference touched feature IDs in the commit body when applicable (e.g., `Closes F005`)
- [ ] Do NOT push without code review (per the review workflow in `CLAUDE.md`)

### 5. Decide on Handoff
Apply this rule:
- [ ] If any of the following hold, write `.claude-handoff.md` from `templates/handoff.template.md`:
  - WIP changes remain uncommitted at session end
  - Next steps are non-trivial (>1 logical action)
  - Context reset planned for next session
  - A different agent will continue the work
- [ ] If none hold and the next session can resume from `git log` + `.claude-features.json` alone, skip handoff

### 6. Sprint Contract Sign-off (if active)
- [ ] If a Sprint Contract drove this session, update `.claude-sprints/<sprint-id>.md`:
  - Mark Definition of Done items completed this session
  - Update Sign-off section if Generator/Evaluator finished their pass
  - If DoD is fully met: mark sprint complete and note in commit body

## Editing Policy
DO NOT remove checklist items. Reorder only with team agreement. ALLOWED: append project-specific items at the end of each section.

## Reference Example
A filled-in example for the same hypothetical project "todo-api" (continuation of the session-start example — F005 reaches `passed` here):

### 1. Working Tree State
- [x] `git status --short` → 3 files modified (routes/todos.py, db/todo_queries.py, tests/test_todos.py)
- [x] No editor swap files; no stray logs
- [x] `git diff --stat` → 3 files, +47 / -8 (matches search-filter scope)

### 2. Update Feature Status
- [x] F005 marked `passed` after running curl/playwright/db verification_steps
- [x] `updated_at` set to 2026-04-19
- [x] F006 remains `in_progress` with note "openapi doc update pending"

### 3. Re-run Smoke
- [x] `./init.sh` → `init.sh OK`, HTTP 200, DB smoke passed

### 4. Commit
- [x] `git add -p` staged only intentional changes
- [x] Commit: `feat(api): add ?q= filter to GET /api/todos (Closes F005)`
- [x] Did not push; code review pending

### 5. Decide on Handoff
- [x] WIP exists (F006 openapi doc update) → wrote `.claude-handoff.md`
- [x] Next P0 = "finish openapi spec for ?q= parameter"

### 6. Sprint Contract Sign-off
- [x] `.claude-sprints/SP-007.md` → DoD 5/7 complete
- [x] Generator sign-off recorded; Evaluator pending
