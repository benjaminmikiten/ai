# GitHub Dev Team Skills — Design

**Date:** 2026-06-16  
**Status:** Approved

## Overview

A composable set of Claude Code skills that simulate a software development team operating autonomously via GitHub issues and PRs. The user acts as Product Manager and Engineering Manager, approving PRDs and ADRs via natural language GitHub comments. All other work runs AFK.

## State Machine

GitHub issue labels track workflow position:

```
needs-po → prd-pending → prd-approved → adr-pending → adr-approved → in-progress → needs-review → done
```

Label transitions:
- `/po` runs → applies `prd-pending`
- Next invocation reads approval comment → transitions to `prd-approved`
- `/tech-lead` runs → applies `adr-pending`
- Next invocation reads approval comment → transitions to `adr-approved`
- `/engineer` runs → applies `in-progress`
- `/review` approves → applies `done`

Each skill checks the current label state before acting and refuses to run if preconditions are not met.

## Architecture

**Option A: Four flat independent skills** with a shared reference doc.

- `/po`, `/tech-lead`, `/engineer`, `/review` — each self-contained
- `/dev-cycle` — orchestrates the full chain, pausing at each HITL gate
- `docs/agents/dev-workflow.md` — per-repo reference doc defining label vocabulary, naming conventions, and approval heuristics

The GitHub issue is the source of truth. Skills communicate via GitHub (issue comments, labels, branch commits, PR review comments) — not via in-conversation state.

## Shared Reference Doc (`docs/agents/dev-workflow.md`)

Lives in each target repo. Defines:

- **Label vocabulary**: exact label strings mapped to workflow states
- **Branch naming**: `feature/<issue-number>-<slug>`
- **PRD path**: `docs/prd/<issue-number>-<slug>.md`
- **ADR path**: `docs/adr/<issue-number>-<slug>.md`
- **Approval heuristic**: how to interpret NL comments as approved / revision-requested / no-response
- **Preconditions per skill**: what state each skill requires before running

## Skill Designs

### `/po #<issue>`

**Precondition:** Issue exists.

1. Read issue body and existing comments.
2. If a PRD draft exists and has revision comments from the user: incorporate feedback, update `docs/prd/` on the branch, re-post as a comment.
3. If no PRD exists: draft PRD using the `to-prd` template, open branch `feature/<issue>-<slug>`, commit to `docs/prd/<issue>-<slug>.md`, post as issue comment.
4. Apply label `prd-pending`.
5. Halt — post a comment directing the user to review on GitHub.

### `/tech-lead #<issue>`

**Precondition:** Issue has `prd-approved` label (i.e. approval comment has been detected and label transitioned from `prd-pending`).

1. Read PRD from branch.
2. Draft ADR: problem, alternatives considered, decision, consequences.
3. Commit to `docs/adr/<issue>-<slug>.md` on the existing feature branch.
4. Post ADR as issue comment.
5. Apply label `adr-pending`. Halt.

### `/engineer #<issue>`

**Precondition:** Issue has `adr-approved` label.

**First invocation (no child issues yet):**
1. Call `/to-issues` on the ADR to produce vertical-slice child issues with `ready-for-agent` label.
2. Begin implementing the first unfinished child issue.

**Subsequent invocations / child issue invocation:**
1. Read open PR review comments (if PR exists).
2. If review comments present: address each one, push new commits, re-request review.
3. If no PR yet: implement the slice, open draft PR targeting the feature branch.
4. Mark child issue resolved when PR passes review.

### `/review #<issue>`

**Precondition:** An open PR exists for the issue or a child issue.

1. Run two-axis review (Standards + Spec), using PRD + ADR as spec source.
2. Post findings as PR review comments.
3. If no issues: approve PR.
4. If issues: request changes — engineer loop re-engages.

### `/dev-cycle #<issue>`

Orchestrates the full chain. On each invocation:

1. Read current issue label state.
2. Advance to the next runnable skill.
3. At HITL gates (`prd-pending`, `adr-pending`): read comment thread for approval signal. If approved, transition label (`prd-pending` → `prd-approved`, `adr-pending` → `adr-approved`) and continue. If revision requested, re-invoke the appropriate skill with extracted feedback. If no response, halt and direct user to GitHub.
4. In the engineer-review loop: re-invoke `/engineer` until `/review` approves, then merge and close.

## Engineer–Review Loop

```
engineer implements → /review →
  changes requested → /engineer reads PR comments, fixes, pushes → /review
  approved → merge PR, close child issue → next child issue or close parent
```

`/dev-cycle` drives this by checking the PR's latest review state after each pass.

## GitHub Integration

All GitHub operations use `gh` CLI:

| Operation | Command pattern |
|-----------|----------------|
| Read issue state | `gh issue view #N --json labels,comments,body` |
| Post comment | `gh issue comment #N --body "..."` |
| Apply label | `gh issue edit #N --add-label "..."` |
| Create branch + commit | `git checkout -b feature/N-slug && git commit` |
| Open draft PR | `gh pr create --draft --base feature/N-slug` |
| Mark PR ready | `gh pr ready` |
| Post PR review | `gh pr review --request-changes` / `--approve` |
| Create child issues | via `/to-issues` skill |

**Approval detection:** On each invocation, the skill reads comments posted since the last agent comment. It interprets the user's natural language response as one of: `approved`, `revision-requested` (with extracted feedback), or `no-response`. If `no-response`, it halts and surfaces what is waiting.

## Out of Scope

- Automatic triggering from GitHub webhooks (future)
- Parallel engineer agents working multiple child issues simultaneously (future)
- Handling merge conflicts on the feature branch
- Non-GitHub issue trackers
