# vs-skills

**ULTIMATE EDITION** - AI-first skills for VS coding, now with infinite retry, self-healing, and completion proof.

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
curl -fsSL https://raw.githubusercontent.com/kks0488/vs-skills/main/bootstrap.sh | bash
```

Windows (PowerShell):
```powershell
irm https://raw.githubusercontent.com/kks0488/vs-skills/main/bootstrap.ps1 | iex
```

## Usage

### Maximum Power Mode (끝판왕)

**The shortest, most powerful command:**
```
vsf: build a login page
```

Or longer versions:
```
use vsf: build a login page
vs finish build a login page
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
vs go build a login page
```

Router analyzes your request and picks the best skill automatically.

### Korean Shortcuts

```
끝까지: 로그인페이지 만들어줘
그냥해줘: 로그인페이지 만들어줘
ㄱㄱ: 로그인페이지 만들어줘
```

## Core Skills (ULTIMATE EDITION)

### vs-phase-loop
**The Ultimate Execution Engine**
- 10/20 phase planning
- Infinite retry on failure
- Self-healing protocol
- Completion proof required
- No questions, no stopping

### vs-router
**Intelligent Skill Selection**
- Intent classification (action, domain, output, scope)
- Confidence scoring
- Skill composition when needed
- Smart fallback (never "I don't know")

### git-dual-terminal-loop
**Parallel Author/Reviewer Workflow**
- Terminal A writes, Terminal B reviews
- Rapid feedback via PR comments
- Self-healing merge conflicts
- Never wait idle

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
vs install       # Install skills
vs update        # Update skills
vs doctor        # Check installation
vs list          # List installed skills
vs go <task>     # Router mode (auto-select skill)
vsf: <task>      # Maximum power mode (끝판왕) ← RECOMMENDED
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

- VS coders who want outcomes, not explanations
- People who prefer "tell AI the goal, review the result"
- Teams that want Git as single source of truth
- Anyone who wants AI to complete tasks, not stop at problems
- Non-technical users who just want things done

## Skills List

| Skill | Purpose |
|-------|---------|
| `vs-phase-loop` | Autonomous execution engine |
| `vsf` | Alias for vs-phase-loop (vs finish) |
| `vs-router` | Intelligent skill selection |
| `git-dual-terminal-loop` | Parallel author/reviewer workflow |
| `frontend-design` | Bold UI builds |
| `web-artifacts-builder` | Multi-file React artifacts |
| `webapp-testing` | Web application testing |
| `docx` / `pptx` / `pdf` / `xlsx` | Document workflows |
| `theme-factory` | Theme/styling systems |
| `brand-guidelines` | Brand identity |
| `algorithmic-art` | Generative art |
| `canvas-design` | Posters and visuals |
| `mcp-builder` | MCP server creation |
| `skill-creator` | New skill creation |

## Installation

Manual install:
```bash
git clone https://github.com/kks0488/vs-skills.git
cd vs-skills
bash scripts/install-skills.sh
```

The installer copies skills to `~/.codex/skills` with timestamped backups.

## Philosophy

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   THE VS PROMISE                                            │
│                                                             │
│   You say "끝까지"                                           │
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
