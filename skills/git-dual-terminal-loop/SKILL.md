---
name: git-dual-terminal-loop
description: Ultimate parallel author/reviewer workflow. Git as single source of truth with automatic PR management, instant feedback loops, and self-healing merges.
---

# Dual Terminal Git Loop - ULTIMATE EDITION

## Core Philosophy

```
┌─────────────────────────────────────────────────────────────┐
│                   PARALLEL EXCELLENCE                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. GIT IS TRUTH - All changes via commits                  │
│  2. PARALLEL IS POWER - A writes, B reviews simultaneously  │
│  3. FEEDBACK IS INSTANT - PR comments, not meetings         │
│  4. RECOVERY IS AUTOMATIC - Self-healing on conflicts       │
│  5. COMPLETION IS PROVEN - Tests pass, review approved      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Invoke

- `use git-dual-terminal-loop: start A/B workflow`
- `set up author/reviewer loop for this repo`
- "PR 워크플로우 시작", "터미널 두개로 작업"

---

## The Dual Loop Engine

### Role Separation

```
┌─────────────────────────────────────────────────────────────┐
│              TERMINAL ROLES                                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  TERMINAL A (Author)                                        │
│  ├─ Edits code                                              │
│  ├─ Commits in small units (50-200 LOC)                     │
│  ├─ Pushes to remote                                        │
│  ├─ Creates/updates PR                                      │
│  ├─ Resolves feedback                                       │
│  └─ ONLY terminal that modifies files                       │
│                                                             │
│  TERMINAL B (Reviewer)                                      │
│  ├─ Fetches and reviews diffs                               │
│  ├─ Runs tests                                              │
│  ├─ Leaves line comments                                    │
│  ├─ Summarizes findings in PR                               │
│  └─ NEVER modifies code (read-only)                         │
│                                                             │
│  RULE: Keep roles STRICT. Cross-contamination = chaos.      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### The Rapid Feedback Loop

```
┌─────────────────────────────────────────────────────────────┐
│              RAPID ITERATION CYCLE                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  [A] Create branch → commit → push → open PR                │
│       ↓                                                     │
│  [B] Fetch → review diff → run tests → comment              │
│       ↓                                                     │
│  [A] Read feedback → fix → commit → push                    │
│       ↓                                                     │
│  [B] Re-review → approve OR request more changes            │
│       ↓                                                     │
│  [A] If approved → merge → delete branch                    │
│       ↓                                                     │
│  REPEAT until all features complete                         │
│                                                             │
│  TARGET: < 5 minutes per feedback cycle                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Self-Healing Protocols

### Merge Conflict Resolution

```
Conflict Detected (on A)
    ↓
git fetch origin
    ↓
git rebase origin/main (or target branch)
    ↓
Resolve conflicts automatically where possible:
  - Accept "ours" for style changes
  - Accept "theirs" for newer dependencies
  - Merge manually for logic conflicts
    ↓
Run tests to verify resolution
    ↓
Force push with lease (safe)
    ↓
Continue PR review
```

### Failed Test Recovery

```
Tests Fail (on B)
    ↓
Analyze failure output
    ↓
Create specific feedback in PR comment:
  - Which test failed
  - Expected vs actual
  - Suggested fix (if obvious)
    ↓
[A] receives notification
    ↓
[A] fixes and pushes
    ↓
[B] re-runs tests
    ↓
LOOP until all tests pass
```

### PR Review Recovery

```
Review Rejected
    ↓
Read all comments
    ↓
Categorize:
  - Blocking (must fix)
  - Suggestions (consider)
  - Questions (answer in comment)
    ↓
[A] Address blocking issues first
    ↓
[A] Push fixes
    ↓
[B] Re-review only changed lines
    ↓
LOOP until approved
```

---

## Parallel Optimization

### Maximize Throughput

```
RULE: While B reviews PR #1, A starts PR #2

Timeline:
  A: [PR1 code] [PR2 code] [PR1 fix] [PR3 code] [PR2 fix]
  B: [------] [PR1 review] [------] [PR2 review] [PR1 re-review]

NEVER: A waits idle for B to finish review
ALWAYS: A starts next task while waiting
```

### Worktree Strategy

```bash
# Set up parallel worktrees
git worktree add ../repo-author main     # Terminal A
git worktree add ../repo-reviewer main    # Terminal B

# Benefits:
# - No branch switching needed
# - Each terminal has clean state
# - Can work on different branches simultaneously
```

---

## Command Reference

### Terminal A (Author)

```bash
# Start new feature
git checkout -b feature/<name>

# Make changes and commit
git add -A
git commit -m "feat: <description>"

# Push and create PR
git push -u origin feature/<name>
gh pr create --fill

# After feedback
git add -A
git commit -m "fix: address review feedback"
git push

# Merge when approved
gh pr merge --squash --delete-branch
```

### Terminal B (Reviewer)

```bash
# Fetch latest
git fetch origin

# Review PR
gh pr view <number>
gh pr diff <number>

# Run tests
npm test  # or appropriate test command

# Leave feedback
gh pr comment <number> --body "Review feedback..."
gh pr review <number> --comment --body "Detailed review..."

# Approve
gh pr review <number> --approve
```

---

## Quality Gates

### Before Merge (Required)

```
□ All tests pass (on B)
□ Code review approved (by B)
□ No merge conflicts
□ PR description complete
□ Related issues linked
```

### Commit Standards

```
Format: <type>: <description>

Types:
- feat: New feature
- fix: Bug fix
- refactor: Code change (no feature/fix)
- test: Adding tests
- docs: Documentation only
- chore: Maintenance

Examples:
✓ feat: add user authentication
✓ fix: resolve null pointer in login
✗ updated stuff (too vague)
✗ WIP (never commit WIP)
```

---

## Performance Tips

1. **Small Commits** - 50-200 LOC per commit
2. **Early PRs** - Open draft PR as soon as first commit
3. **Parallel Work** - A works on next while B reviews
4. **Quick Tests** - Run fast smoke test first, full suite before merge
5. **Clear Comments** - Actionable feedback, not vague suggestions

---

## OpenCode Mapping

```
┌─────────────────────────────────────────────────────────────┐
│              OPENCODE INTEGRATION                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Terminal A = OpenCode "build" agent                        │
│  ├─ Edits, commits, pushes                                  │
│  └─ Full write access                                       │
│                                                             │
│  Terminal B = OpenCode "plan" agent                         │
│  ├─ Read-only review, tests, comments                       │
│  └─ No file modifications                                   │
│                                                             │
│  Switch roles with Tab only if absolutely necessary         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Codex Role Prompts

### Terminal A (Author)

```text
Role: Terminal A (Author).
Rules:
- ONLY edit, commit, push
- Make safe default choices, record assumptions
- Ask questions only at the end
- Communicate via PR, not chat
- Small commits (50-200 LOC)
- Never wait for B - start next task
```

### Terminal B (Reviewer)

```text
Role: Terminal B (Reviewer).
Rules:
- NEVER edit code
- Review diffs, run tests, leave PR comments
- Request changes from A, don't fix yourself
- Be specific and actionable in feedback
- Approve only when tests pass AND code is clean
```

---

## The Dual Loop Promise

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   TWO TERMINALS. ONE TRUTH.                                 │
│                                                             │
│   A WRITES. B REVIEWS.                                      │
│   PARALLEL WORK. RAPID FEEDBACK.                            │
│   CONFLICTS HEAL. TESTS MUST PASS.                          │
│   PR IS THE RECORD. GIT IS THE LAW.                         │
│                                                             │
│   NO MEETINGS. NO SLACK. NO CONFUSION.                      │
│   JUST CODE. REVIEW. MERGE. SHIP.                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```
