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
- Core flows are sub-agent aware (uses Codex collaboration tools for parallel recon/testing when available).

## Usage

### Maximum Power Mode

**The shortest, most powerful command:**
```
vcf: build a login page
```

Or longer versions:
```
use vcf: build a login page
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
vc install [--repo]          # Install vc skills
vc update [--repo]           # Update repo + reinstall skills
vc doctor        # Check installation
vc list          # List installed skills
vc mcp docs      # Add OpenAI dev docs MCP server
vc mcp skills    # Add vibe skills MCP server (npx)
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
| `vcf` | Alias for `vc-phase-loop` |
| `vcg` | Alias for `vc-router` |

## Installation

Manual install:
```bash
git clone https://github.com/kks0488/vibe-codex.git
cd vibe-codex
bash scripts/install-skills.sh                 # Core skills (default), user scope (~/.codex/skills)
bash scripts/install-skills.sh --repo          # Core skills, repo scope (<repo>/.codex/skills)
```

The installer copies skills to the selected scope and moves any overwritten skills into a sibling `skills.bak-<timestamp>` folder (outside your `skills/` directory). Restart Codex to pick up new skills.

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
