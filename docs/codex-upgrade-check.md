# Codex CLI upgrade checklist (for vibe-codex)

This repo is designed to work with OpenAI Codex CLI’s current skills system (recursive `SKILL.md` discovery, sandbox/approvals, MCP, collaboration tools).

## High-signal upstream changes (Codex CLI)

- Skills discovery is recursive and layered (repo `.codex/skills`, user `$CODEX_HOME/skills`, system `.system`, admin), so **extra folders inside your skills root can become loadable skills**.
- New sandbox/approvals guidance and commands (including `/permissions` as a shorter alias) and clearer defaults.
- MCP + “apps/connectors” surfaces are now first-class; Codex can connect to remote/local MCP servers via config or `codex mcp`.
- Collaboration tooling evolved (`spawn_agent` role presets, `send_input --interrupt`), and Codex now caps sub-agents (currently 6).
- Optional `SKILL.json` supports richer skill UI metadata (`interface`, icons, `brand_color`, `default_prompt`, dependencies).

## Changes applied in this repo

- `scripts/install-skills.sh` and `scripts/install-skills.ps1` now place backups **outside** the skills directory (`skills.bak-<timestamp>`), preventing Codex from loading backups as duplicate skills.
- Skills now live under repo `.codex/skills` (Codex can discover them directly in-repo; installers copy from the same canonical location).
- `scripts/doctor.sh` and `scripts/doctor.ps1` now:
  - Align skill validation with Codex CLI limits (name ≤ 64, description ≤ 1024, short-description ≤ 1024; validates `SKILL.json` when present).
  - Skip non-skill folders (no `SKILL.md`) instead of warning.
  - Detect legacy `*.bak-*` skill folders and warn that they will load as duplicates.
  - Check whether the OpenAI Developer Docs MCP server is configured.
- Added `SKILL.json` metadata for `vc-phase-loop`, `vc-router`, `vcf`, `vcg` to improve the Codex UI.
- Declared the OpenAI Developer Docs MCP server as a skill dependency (Codex can auto-prompt/install missing MCP servers).

## Recommended setup

- Keep Codex CLI current (Homebrew: `brew upgrade --cask codex`, npm: `npm i -g @openai/codex`).
- Install skills:
  - vc skills (default): `bash scripts/install-skills.sh`
  - Repo scope: add `--repo` (e.g. `bash scripts/install-skills.sh --repo`)
- Sub-agents (collaboration tools):
  - Check feature flags: `codex features list` (look for `collab`)
  - vibe-codex core skills are written to be **sub-agent aware** (parallel recon/testing when available; fallback to sequential when not).
  - Prefer read-only sub-tasks; keep ≤4 agents (Codex cap may be 6) and close them after collecting results.
- Add OpenAI Developer Docs MCP (lets Codex pull OpenAI docs into context):
  - `vc mcp docs` (or: `codex mcp add openaiDeveloperDocs --url https://developers.openai.com/mcp`)
  - Note: vibe-codex core skills declare this MCP server as a dependency in `SKILL.json`, so Codex may prompt to install it automatically.

## Cleanup (if you used older installers)

If you see folders like `vc-router.bak-202601...` in `~/.codex/skills`, Codex may load them as duplicate skills. Move them out of `~/.codex/skills` (e.g. to `~/.codex/skills.bak-<timestamp>`) or delete them if you don’t need them.

If you previously installed older vibe-codex bundles and want a clean vc-only skills directory, run `vc prune` (backs up removed skills).
