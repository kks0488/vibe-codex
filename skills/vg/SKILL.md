---
name: vg
description: Short, explicit alias for vibe-router. Use when the user says "vg", "use vg", or wants the shortest reliable router command.
---

# VG (Vibe Go Alias)

## Vibe Defaults

- Prefer fast iteration and shipping a working baseline over perfection.
- Make safe default choices without pausing; record assumptions briefly.
- Ask questions only after delivering an initial result, unless the workflow requires confirmation for safety/legal reasons.
- Keep outputs concise, actionable, and easy to extend.
- Assume the user is non-technical; avoid long explanations and provide copy/paste steps when actions are required.

## Vibe Fast Path

- Classify the task in one pass.
- Select a single best-fit skill; avoid chaining unless required.
- Execute immediately; collect assumptions and questions for the end.
- If the task is multi-step or open-ended, default to a finish-style workflow.

## Vibe Quick Invoke

- `use vg: <goal>`

## Routing Rules

- Finish-to-end requests: use a finish-style plan/execute/test workflow.
- Planning/execution loops: use a finish-style plan/execute/test workflow.
- Two-terminal Git workflow: git-dual-terminal-loop
- Frontend UI build: frontend-design
- Multi-file React artifact: web-artifacts-builder
- Web app testing: webapp-testing
- Docs/office files: docx, pptx, pdf, xlsx
- Theming: theme-factory
- Branding: brand-guidelines
- MCP servers: mcp-builder
- Art or posters: algorithmic-art or canvas-design
- Internal updates/comms: internal-comms
- New skill creation: skill-creator

## Execution Rules

- Read only the selected skill's SKILL.md and follow its defaults.
- Keep the user flow simple: deliver a first pass, then ask for corrections.
- If uncertain between two skills, pick the one with narrower scope.
- If the user says only `vg` with no goal, ask for the goal and stop; do not guess by scanning the filesystem.
