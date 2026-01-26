---
name: vc-router
description: Intelligent skill routing with automatic selection, composition, and fallback. Use when the user doesn't specify a skill, says "just do it", or wants the AI to decide the best approach.
---

# VC Router - ULTIMATE EDITION

## Core Philosophy

```
┌─────────────────────────────────────────────────────────────┐
│                   INTELLIGENT ROUTING                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. UNDERSTAND INTENT - Not just keywords                   │
│  2. SELECT BEST FIT - With confidence scoring               │
│  3. COMPOSE IF NEEDED - Chain skills intelligently          │
│  4. FALLBACK GRACEFULLY - Always have a path forward        │
│  5. LEARN FROM RESULTS - Improve routing over time          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Invoke

Any of these activate the router:
- `use vc-router: <goal>`
- `just do this: <goal>`
- `vc go <goal>` (router mode)
- `vc finish <goal>` (force end-to-end)
- `vcf: <goal>` → routes to vc-phase-loop (끝판왕)
- `use vcf: <goal>` → same as above
- Korean: "그냥해줘", "걍해줘", "ㄱㄱ", "끝까지", "아무것도 모르겠다"

---

## The Routing Engine

### Step 1: Intent Classification

```
┌─────────────────────────────────────────────────────────────┐
│              INTENT CLASSIFICATION                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Extract from user request:                                 │
│  ├─ ACTION: What to do (build, create, fix, analyze...)    │
│  ├─ DOMAIN: What area (frontend, backend, docs, git...)    │
│  ├─ OUTPUT: Expected result (file, component, document...) │
│  └─ SCOPE: Size of task (single file, multi-file, system)  │
│                                                             │
│  Example: "Build a login page with OAuth"                   │
│  ├─ ACTION: build                                           │
│  ├─ DOMAIN: frontend                                        │
│  ├─ OUTPUT: page/component                                  │
│  └─ SCOPE: multi-file                                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Step 1.5: Sub-Agent Assisted Routing (Optional)

If the request is **large, ambiguous, or multi-domain**, spawn **1–2 sub-agents** to parallelize:
- Repo scan: locate relevant code/config and constraints
- Risk scan: identify security/ops risks and validation strategy

Rules:
- Keep it lightweight (max 2) and timeboxed.
- Sub-agents report findings only; main agent makes routing decision.
- If sub-agents aren’t available, continue without them.

### Step 2: Skill Matching

```
┌─────────────────────────────────────────────────────────────┐
│              SKILL MATCHING MATRIX                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  EXECUTION PATTERNS:                                        │
│  ├─ "끝까지", "finish", "hands off" → vc-phase-loop       │
│  ├─ Multi-step, open-ended → vc-phase-loop                │
│  └─ Autonomous completion needed → vc-phase-loop          │
│                                                             │
│  GIT/VERSION CONTROL:                                       │
│  ├─ PR workflow, review → git-dual-terminal-loop            │
│  ├─ Two-terminal, author/reviewer → git-dual-terminal-loop  │
│  └─ "gh", "glab", delta → git-dual-terminal-loop            │
│                                                             │
│  FRONTEND/UI:                                               │
│  ├─ UI, component, page → frontend-design                   │
│  ├─ React artifact, multi-file React → web-artifacts-builder│
│  └─ Testing webapp → webapp-testing                         │
│                                                             │
│  DOCUMENTS:                                                 │
│  ├─ Word, .docx → docx                                      │
│  ├─ PowerPoint, .pptx, presentation → pptx                  │
│  ├─ PDF, forms → pdf                                        │
│  ├─ Excel, .xlsx, spreadsheet → xlsx                        │
│  └─ Co-authoring, collaborative → doc-coauthoring           │
│                                                             │
│  CREATIVE:                                                  │
│  ├─ Theme, colors, styling system → theme-factory           │
│  ├─ Brand, logo, identity → brand-guidelines                │
│  ├─ Algorithmic art, generative → algorithmic-art           │
│  ├─ Canvas, poster, visual → canvas-design                  │
│  └─ Slack GIF, animation → slack-gif-creator                │
│                                                             │
│  DEVELOPMENT:                                               │
│  ├─ MCP server, tool creation → mcp-builder                 │
│  ├─ New skill creation → skill-creator                      │
│  └─ Internal comms, updates → internal-comms                │
│                                                             │
│  FALLBACK:                                                  │
│  └─ Unknown/ambiguous → vc-phase-loop (safe default)      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Step 3: Confidence Scoring

```
For each potential skill match, calculate confidence:

HIGH (80-100%): Clear keyword match + domain match
  → Route immediately

MEDIUM (50-79%): Partial match, some ambiguity
  → Select best fit, proceed with note

LOW (<50%): Weak match, unclear intent
  → Use vc-phase-loop as safe default
```

---

## Skill Composition

### When to Chain Skills

```
┌─────────────────────────────────────────────────────────────┐
│              SKILL COMPOSITION RULES                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  CHAIN these skill pairs when detected:                     │
│                                                             │
│  "Branded landing page"                                     │
│  → brand-guidelines THEN frontend-design                    │
│                                                             │
│  "Presentation from document"                               │
│  → docx (read) THEN pptx (create)                           │
│                                                             │
│  "React app with tests"                                     │
│  → web-artifacts-builder THEN webapp-testing                │
│                                                             │
│  "Themed presentation"                                      │
│  → theme-factory THEN pptx                                  │
│                                                             │
│  SINGLE SKILL for:                                          │
│  - Clear single-domain requests                             │
│  - Simple tasks                                             │
│  - When composition adds no value                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Composition Execution

```
When chaining:
1. Execute first skill
2. Pass output as context to second skill
3. If any skill fails, apply SELF-HEALING from vc-phase-loop
4. Continue until all skills complete
```

---

## Fallback Strategy

### When No Skill Matches

```
┌─────────────────────────────────────────────────────────────┐
│              FALLBACK HIERARCHY                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Level 1: Check if task is code-related                     │
│  └─ YES → vc-phase-loop (autonomous execution)            │
│                                                             │
│  Level 2: Check if task is document-related                 │
│  └─ YES → docx/pptx/pdf/xlsx based on output format         │
│                                                             │
│  Level 3: Check if task is creative/visual                  │
│  └─ YES → canvas-design (flexible creative tool)            │
│                                                             │
│  Level 4: Unknown domain                                    │
│  └─ ALWAYS → vc-phase-loop                                │
│                                                             │
│  NEVER: "I don't know which skill to use"                   │
│  ALWAYS: Route to vc-phase-loop as universal fallback     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Error Recovery

### When Selected Skill Fails

```
Skill Failed
    ↓
Analyze failure reason
    ↓
Option 1: Retry same skill with adjusted approach
    ↓
Option 2: Try alternative skill from same category
    ↓
Option 3: Decompose task and route parts separately
    ↓
Option 4: Escalate to vc-phase-loop for full autonomy
    ↓
NEVER: Stop and report failure without attempting recovery
```

---

## VC Defaults

For ALL routing decisions:
- Prefer fast iteration over perfection
- Make safe default choices without pausing
- Ask questions only after delivering initial result
- Keep outputs concise and actionable
- Assume user is non-technical

---

## VC Finish Mode

When user triggers "vc finish" explicitly:
- ALWAYS route to vc-phase-loop
- Enable full autonomous execution
- No mid-stream questions
- Complete end-to-end
- Provide completion proof

Triggers:
- "vc finish", "finish it", "take it to the end"
- "끝까지", "끝까지 해줘", "그냥해줘", "걍해줘", "ㄱㄱ"
- "아무것도 모르겠다", "마무리까지 해줘"

---

## Execution Rules

1. **Single Pass Classification** - Decide quickly, don't overthink
2. **Best Fit Selection** - If uncertain, choose narrower scope skill
3. **Immediate Execution** - Route and run, collect questions for end
4. **Safe Defaults** - vc-phase-loop handles anything
5. **No Dead Ends** - Always have a path forward

---

## Routing Decision Log

For transparency, log routing decisions:

```markdown
## Routing Decision

Request: "Build a login page"
Classification:
  - Action: build
  - Domain: frontend
  - Output: page
  - Scope: multi-file

Candidates:
  1. frontend-design (90% match)
  2. web-artifacts-builder (70% match)

Selected: frontend-design
Reason: Direct UI build request, single component focus

Proceeding with execution...
```

---

## The Router Promise

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   YOU SAY WHAT YOU WANT.                                    │
│                                                             │
│   WE UNDERSTAND YOUR INTENT.                                │
│   WE SELECT THE BEST SKILL.                                 │
│   WE COMPOSE IF NEEDED.                                     │
│   WE RECOVER FROM FAILURES.                                 │
│   WE ALWAYS HAVE A PATH FORWARD.                            │
│                                                             │
│   NO "I DON'T KNOW" - ALWAYS ROUTE.                         │
│   NO DEAD ENDS - ALWAYS FALLBACK.                           │
│   NO FAILURES - ALWAYS RECOVER.                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```
