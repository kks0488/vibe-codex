# vibe-codex (Codex CLI)

This repo is **Codex-first** and ships skills under `.codex/skills`.

## Repo conventions

- Keep `scripts/*.sh` and `scripts/*.ps1` feature-parity (same subcommands + flags).
- Skills live in `.codex/skills/<skill>/SKILL.md` (+ optional `agents/openai.yaml` UI metadata + dependency hints; optional legacy `SKILL.json`). Tip: keep `agents/openai.yaml` JSON-formatted (JSON ⊂ YAML) so doctor scripts can validate without extra deps.
- Codex docs now prefer `.agents/skills`; this repo keeps `.codex/skills` as the canonical source and installers can target `.agents/skills` via `--agents`.
- For `SKILL.md` YAML frontmatter, keep `name` ≤ 64, `description` ≤ 1024, and `metadata.short-description` ≤ 1024.
- When changing skills, keep `SKILL.md` ↔ `agents/openai.yaml` (and `SKILL.json` if present) aligned and run `bash scripts/doctor.sh`.
- Avoid creating backup folders inside any skills directory (Codex loads skills recursively and backups can become duplicate skills).

## OpenAI docs

- Prefer the OpenAI Developer Docs MCP server when you need up-to-date OpenAI/Codex/API info.
  - Setup: `vc mcp docs` (or `codex mcp add openaiDeveloperDocs --url https://developers.openai.com/mcp`)

## Handy commands

- Diagnose: `bash scripts/doctor.sh` (or `pwsh scripts/doctor.ps1`)
- Install skills: `bash scripts/install-skills.sh [--agents]` (or `pwsh scripts/install-skills.ps1 [--agents]`)
- MCP helpers: `vc mcp docs`, `vc mcp skills`, `vc mcp list`
