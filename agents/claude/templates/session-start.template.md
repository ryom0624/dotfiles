> Copy this file to `.claude-session-start.md` in your project root. Run through it at the start of every session.

# Session Start Checklist: {{project_name}}

This checklist exists so the first 10 minutes of every session establish a verified, cold-start-safe baseline before any new work begins.

## When to Use
- At the very beginning of every session, before opening new tasks
- After a context reset or handoff
- After pulling a long batch of changes from another agent or branch

## Time Budget
- Target: complete in **10 minutes or less**
- If a step takes longer than 5 minutes, stop and write `.claude-handoff.md` instead of forcing progress

## Checklist

### 1. Working Directory & Git
- [ ] Confirm `pwd` matches the expected project root
- [ ] Run `git status --short` → tree clean OR known WIP listed in `.claude-handoff.md`
- [ ] Run `git log --oneline -5` → understand the last 5 commits and authors
- [ ] Confirm current branch and upstream: `git branch -vv`

### 2. Progress State
- [ ] Read `.codex-progress.json` if present → note current task IDs and statuses
- [ ] Read `.claude-features.json` → note completed (`passed`) vs in-flight (`in_progress`) features
- [ ] Read `.claude-handoff.md` if present → follow Next Steps (Prioritized) order

### 3. Pick the Next Feature
Apply step 3a first; only proceed to step 3b if no `in_progress` features exist.

#### 3a. Resume WIP (highest priority)
- [ ] List features with `status == "in_progress"`
- [ ] If any exist: pick the highest-priority `in_progress` feature, skip step 3b
- [ ] If `.claude-handoff.md` exists, follow its Next Steps (Prioritized) order instead of reading `.claude-features.json` directly

#### 3b. Pick a new feature (only if no `in_progress` exists)
- [ ] `status == "pending"`
- [ ] All `depends_on` IDs have `status == "passed"`
- [ ] Highest priority among eligible candidates (P0 > P1 > P2 > P3)
- [ ] If multiple features tie on priority, pick the lowest ID

Record the chosen feature ID in your working notes before any code change.

### 4. Run init.sh
- [ ] Execute `./init.sh` → wait for `init.sh OK` line
- [ ] If failure: do NOT proceed; investigate `.claude-init.log` and `.claude-init.dev.log` first
- [ ] Confirm dev server health endpoint returned HTTP 200
- [ ] Confirm DB smoke (if `DB_CHECK_CMD` set) and env vars (if `REQUIRED_ENVS` populated) passed

### 5. Verify Active Sprint Contract (if any)
- [ ] If `.claude-sprints/<sprint-id>.md` exists for current work, re-read Definition of Done and Verification Plan
- [ ] Confirm Sign-off section status (Planner / Generator / Evaluator)

### 6. Mark Session Started
- [ ] Update `.claude-features.json` → set the chosen feature `status` to `in_progress` (only if not already)
- [ ] Note start time and selected feature ID in your scratchpad

## Editing Policy
DO NOT remove checklist items. Reorder only with team agreement. ALLOWED: append project-specific items at the end of each section.

## Reference Example
A filled-in example for a hypothetical project "todo-api":

### 1. Working Directory & Git
- [x] `pwd` == `/workspace/todo-api`
- [x] `git status --short` → clean
- [x] `git log --oneline -5` → last commit `8f3c2a1 feat: add ?q= param to GET /api/todos`
- [x] Branch: `feature/search-filter` tracking `origin/feature/search-filter`

### 2. Progress State
- [x] `.codex-progress.json` → task `T-12` in_progress, owner engineer
- [x] `.claude-features.json` → F003 passed, F005 in_progress, F006 pending
- [x] `.claude-handoff.md` → Next Step P0 = "finish empty-query integration test"

### 3. Pick the Next Feature

#### 3a. Resume WIP
- [x] Features with `status == "in_progress"`: F005
- [x] `.claude-handoff.md` exists → follow its Next Steps (Prioritized), starting with P0 "finish empty-query integration test"
- [x] Selected: F005 → skip 3b

#### 3b. Pick a new feature
- [x] Skipped (an `in_progress` feature exists)

### 4. Run init.sh
- [x] `./init.sh` exited 0, `init.sh OK` line confirmed
- [x] Health endpoint 200
- [x] DB smoke OK (DB_CHECK_CMD set), env vars OK

### 5. Verify Active Sprint Contract
- [x] `.claude-sprints/SP-007.md` re-read; DoD 4/7 complete

### 6. Mark Session Started
- [x] F005 already `in_progress` → no status change needed
- [x] Start time 2026-04-19 09:14, selected feature F005
