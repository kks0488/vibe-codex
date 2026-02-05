# Codex CLI upgrade checklist (for vibe-codex)

Verified against `openai/codex` HEAD `7e81f636988bc3115fecd63e79c47f6e1979d44c` on **February 5, 2026**.

## High-signal upstream behavior (Codex CLI)

- Skills are discovered recursively from layered roots. Current docs emphasize `.agents/skills` (repo + user), while Codex still supports legacy `$CODEX_HOME/skills` / repo `.codex/skills` for compatibility.
- Recursive scanning means backup folders inside a skills root can be loaded as duplicate skills.
- `AGENTS.md` discovery is layered and ordered:
  - Global: `~/.codex/AGENTS.override.md` or `~/.codex/AGENTS.md`
  - Project: from project root to CWD (`AGENTS.override.md` first, then `AGENTS.md`, then `project_doc_fallback_filenames`)
  - Combined size is capped by `project_doc_max_bytes` (default 32 KiB).
- Security model uses sandbox mode + approval policy together; `/permissions` is the quick in-session control.
- MCP setup remains first-class via `codex mcp ...`; OpenAI docs MCP URL is `https://developers.openai.com/mcp`.
- Skill metadata is provided via optional `agents/openai.yaml` (YAML; JSON is valid YAML) and optional legacy `SKILL.json`.

## Changes applied in this repo

- `scripts/install-skills.*` now support `--agents`:
  - User scope: `~/.agents/skills`
  - Repo scope: `<repo>/.agents/skills`
  - Legacy default behavior remains unchanged for backward compatibility.
- `scripts/list-skills.*`, `scripts/prune-skills.*`, and `scripts/uninstall-skills.*` now support the same `--agents` target selection.
- `scripts/uninstall-skills.*` now uninstall core vc skills from `scripts/core-skills.txt` (instead of relying on a deprecated local `skills/` source folder).
- `scripts/doctor.*` now checks both user locations:
  - `~/.agents/skills` (docs-style/default in current Codex docs)
  - `$CODEX_HOME/skills` (legacy compatibility path)
- README/setup docs now explain `.agents/skills` vs `.codex/skills` clearly and include `--agents` examples.

## Recommended setup

- Keep Codex CLI current:
  - Homebrew: `brew upgrade --cask codex`
  - npm: `npm i -g @openai/codex`
- Install vibe-codex skills:
  - Docs-style user scope: `bash scripts/install-skills.sh --agents`
  - Legacy-compatible user scope: `bash scripts/install-skills.sh`
  - Repo scope docs-style: `bash scripts/install-skills.sh --repo --agents`
  - Repo scope legacy path: `bash scripts/install-skills.sh --repo`
- Add OpenAI Developer Docs MCP:
  - `vc mcp docs`
  - or `codex mcp add openaiDeveloperDocs --url https://developers.openai.com/mcp`

## Cleanup notes

- If you see folders like `*.bak-*` inside any active skills directory, move them out. Recursive loading can treat them as duplicate skills.
- Check both user locations for stale backups:
  - `~/.agents/skills`
  - `$CODEX_HOME/skills` (typically `~/.codex/skills`)
- For older vibe-codex installs, `vc prune` can remove legacy non-vc skills with backup.
