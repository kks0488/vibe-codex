# vibe-codex

**ULTIMATE EDITION** - Codex-first skills for Vibe Codex, now with infinite retry, self-healing, and completion proof.
Purpose-built for Codex CLI workflows and skill routing.

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   SAY WHAT YOU WANT.                                        │
│   WE PLAN IT. EXECUTE IT. FIX WHATEVER BREAKS.              │
│   RETRY UNTIL SUCCESS. PROVE IT WORKS.                      │
│                                                             │
│   NO QUESTIONS. NO EXCUSES. NO STOPPING.                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Want it simpler?

If you want a fast, minimal plan -> code -> exec loop:
https://github.com/kks0488/codex-triad

If you want deeper, multi-skill automation and routers, stay with vibe-codex.

## What's New in ULTIMATE EDITION

- **Infinite Retry Engine** - Never stops on failure, adapts and retries
- **Self-Healing Protocol** - Auto-diagnoses and fixes errors
- **Completion Proof** - Evidence-based verification, not just "looks done"
- **Parallel Execution** - Independent tasks run simultaneously
- **State Persistence** - Work documents track progress, can resume
- **Skill Composition** - Chains skills intelligently when needed
- **Smart Fallback** - Always has a path forward, no dead ends

## Latest Release (v0.4.1)

- Added **Codex-native Agent Teams** runtime (`vc teams`) with:
  - team lifecycle + membership management
  - mailbox-based protocol (`message`, `broadcast`, shutdown/plan approvals)
  - `watch` + `await` operations for live coordination and strict request-response waits
  - dedupe, stale-lock recovery, and events log (`~/.vc/teams/<team>/events.jsonl`)
- Added new skill: `vc-agent-teams`
- Added PR CI validation for teams E2E (`node --test scripts/vc-teams.test.mjs`)

## Super simple (copy/paste)

One-liner install/update (recommended):

Mac/Linux:
```bash
curl -fsSL https://raw.githubusercontent.com/kks0488/vibe-codex/main/bootstrap.sh | bash
```

Windows (PowerShell):
```powershell
irm https://raw.githubusercontent.com/kks0488/vibe-codex/main/bootstrap.ps1 | iex
```

## Codex CLI compatibility

- Tested against recent `codex-cli` (Rust releases). See `docs/codex-upgrade-check.md` for upgrade notes (skills discovery, sandbox/approvals, MCP, connectors).
- Recommended setup checklist: `docs/codex-setup.md` (MCP + config).
- Recommended: skills are the core (MCP servers are helpers); Codex docs now prefer `.agents/skills`, while vibe-codex keeps `.codex/skills` as canonical source and supports both install targets (`--agents` or legacy default). Skills use `agents/openai.yaml` (plus optional legacy `SKILL.json`) for Codex UI metadata + dependency hints (including OpenAI Docs MCP).
- Core flows are sub-agent aware (uses Codex collaboration tools for parallel recon/testing when available).

## Usage

### Maximum Power Mode

**The shortest, most powerful command:**
```
vcf: build a login page
```

Or via the helper command (prints a `vcf:` prompt for Codex chat):
```
vc finish build a login page
```

This triggers:
1. Auto-creates work document for tracking
2. Plans 10-20 phases
3. Executes all phases (parallel where possible)
4. Self-heals on any failure
5. Runs tests
6. Provides completion proof

### Router Mode (Auto-Select Skill)

```
vc go build a login page
```

Router analyzes your request and picks the best skill automatically.

### Explicit Skill Invocation

Use `/skills` or type `$` to pick a skill explicitly. This works in the CLI and IDE extension; web/iOS still rely on automatic selection.

## Core Skills (ULTIMATE EDITION)

### vc-phase-loop
**The Ultimate Execution Engine**
- 10/20 phase planning
- Infinite retry on failure
- Self-healing protocol
- Completion proof required
- No questions, no stopping
Aliases: `vcf`

### vc-router
**Intelligent Skill Selection**
- Intent classification (action, domain, output, scope)
- Confidence scoring
- Skill composition when needed
- Smart fallback (never "I don't know")
Alias: `vcg`

### vc-agent-teams
**Codex-native Team Orchestration**
- Team lifecycle (`create`, `delete`)
- Member management (`add-member`, `remove-member`)
- Mailbox protocol (`message`, `broadcast`, `shutdown`, `plan approval`)
- File-backed runtime under `~/.vc/teams`

## The Iron Laws

```
1. NEVER STOP UNTIL PROVEN DONE
2. NEVER ASK - DECIDE AND RECORD
3. NEVER FAIL - ADAPT AND RETRY
4. NEVER FORGET - TRACK EVERYTHING
5. NEVER ASSUME DONE - VERIFY WITH EVIDENCE
```

## Shortcut Commands

```bash
vc install [--repo|--agents|--path <dir>]  # Install vc skills
vc update [--repo|--agents|--path <dir>]   # Update repo + reinstall skills
vc doctor        # Check installation
vc list          # List installed skills
vc teams <cmd>   # Team lifecycle + mailbox commands
vc mcp docs      # Add OpenAI dev docs MCP server
vc mcp skills    # Add vibe skills MCP server (npx)
vc mcp list      # List configured MCP servers
vc go <task>     # Router mode (auto-select skill)
vcf: <task>      # Maximum power mode (recommended)
```

## Completion Proof Format

Every task ends with proof:

```markdown
## COMPLETION PROOF

✓ Executed:
  Command: npm run dev
  Output: Server running on localhost:3000

✓ Tests:
  Command: npm test
  Result: 47 passed, 0 failed

✓ Requirements Verified:
  - [Login page]: src/pages/Login.tsx:1-89
  - [OAuth integration]: src/lib/auth.ts:15-67

✓ Quality Checks:
  - Build: PASS
  - Lint: PASS
  - Types: PASS
```

## Who this is for

- Codex users who want outcomes, not explanations
- People who prefer "tell AI the goal, review the result"
- Teams that want Git as single source of truth
- Anyone who wants AI to complete tasks, not stop at problems
- Non-technical users who just want things done

## Skills

| Skill | Purpose |
|-------|---------|
| `vc-phase-loop` | End-to-end execution engine (sub-agent aware) |
| `vc-router` | Intelligent skill selection (sub-agent assisted when useful) |
| `vc-agent-teams` | Codex-native team lifecycle + mailbox coordination |
| `vcf` | Alias for `vc-phase-loop` |
| `vcg` | Alias for `vc-router` |

## Agent Teams (Codex-native)

The Claude-style Teams concept is implemented for Codex via `vc teams` commands and JSON mailboxes.

```bash
vc teams create --name my-project --description "research + implementation"
vc teams add-member --team my-project --name researcher --agent-type researcher
vc teams add-member --team my-project --name implementer --agent-type coder
vc teams send --team my-project --type message --from team-lead --recipient researcher --content "Map architecture"
vc teams watch --team my-project --interval-ms 500 --max-iterations 5
vc teams status --team my-project
vc teams read --team my-project --agent researcher --unread
```

Protocol notes:
- `shutdown_request` / `plan_approval_request` auto-create `requestId` if missing.
- `shutdown_response` / `plan_approval_response` require `--request-id` and `--approve`.
- Use `vc teams await --team <team> --agent <agent> --request-id <id> --timeout-ms <n>` for strict request-response waits.

Storage layout:

```text
~/.vc/teams/{team}/config.json
~/.vc/teams/{team}/inboxes/{agent}.json
~/.vc/teams/{team}/tasks/
```

## Installation

Manual install:
```bash
git clone https://github.com/kks0488/vibe-codex.git
cd vibe-codex
bash scripts/install-skills.sh                 # Core skills (legacy-compatible): $CODEX_HOME/skills
bash scripts/install-skills.sh --agents        # Core skills (Codex docs default): ~/.agents/skills
bash scripts/install-skills.sh --repo          # Repo scope: <repo>/.codex/skills
bash scripts/install-skills.sh --repo --agents # Repo scope (docs style): <repo>/.agents/skills
```

The installer copies skills to the selected scope and moves any overwritten skills into a sibling `skills.bak-<timestamp>` folder (outside your `skills/` directory). Restart Codex to pick up new skills.
Tip: `vc mcp docs` sets up the OpenAI Developer Docs MCP server (or Codex may prompt to install it because it is declared as a dependency in `agents/openai.yaml` / `SKILL.json`).

If you previously installed older vibe-codex bundles and want a clean vc-only skills directory, run `vc prune` (backs up removed skills).

## Philosophy

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   THE VIBE CODEX PROMISE                                    │
│                                                             │
│   We throw agents at it.                                    │
│   We throw retries at it.                                   │
│   We throw self-healing at it.                              │
│                                                             │
│   Until it's done.                                          │
│   Actually done.                                            │
│   Proven done.                                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```
