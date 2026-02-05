# Codex CLI setup (recommended for vibe-codex)

## 1) Install vibe-codex skills

- One-liner (Mac/Linux): `curl -fsSL https://raw.githubusercontent.com/kks0488/vibe-codex/main/bootstrap.sh | bash`
- Or from this repo:
  - User scope (legacy-compatible): `bash scripts/install-skills.sh` -> `$CODEX_HOME/skills`
  - User scope (Codex docs default): `bash scripts/install-skills.sh --agents` -> `~/.agents/skills`
  - Repo scope (legacy path): `bash scripts/install-skills.sh --repo` -> `<repo>/.codex/skills`
  - Repo scope (docs-style path): `bash scripts/install-skills.sh --repo --agents` -> `<repo>/.agents/skills`
- Restart Codex after installing/updating skills.

## 2) Add OpenAI Developer Docs MCP (highly recommended)

- Via helper: `vc mcp docs`
- Or directly: `codex mcp add openaiDeveloperDocs --url https://developers.openai.com/mcp`
- Note: vibe-codex core skills declare this MCP server as a dependency in `agents/openai.yaml` (and legacy `SKILL.json`), so Codex may prompt to install it automatically.

Why: lets Codex pull official OpenAI/Codex/API docs into context without general web browsing.

## 3) (Optional) Project instructions (AGENTS.md)

Codex loads instructions in layers:
- Global: `~/.codex/AGENTS.override.md` (preferred) or `~/.codex/AGENTS.md`
- Project: from repo root down to CWD, checking `AGENTS.override.md` then `AGENTS.md` (plus fallback names)
- Fallback names are configured by `project_doc_fallback_filenames`

Notes:
- Combined project guidance is capped by `project_doc_max_bytes` (default 32 KiB). Keep files concise or raise the limit in `~/.codex/config.toml`.
- Prefer `AGENTS.override.md` for local, non-committed overrides (quickly switch “persona” without changing `AGENTS.md`).

## 4) (Optional) Enable useful Codex features

You can toggle features via CLI:

- `codex --enable unified_exec`
- `codex --enable apply_patch_freeform`

Or via `~/.codex/config.toml`:

```toml
[features]
unified_exec = true
apply_patch_freeform = true

[mcp_servers.openaiDeveloperDocs]
url = "https://developers.openai.com/mcp"
```

## 5) Verify

- `vc doctor`
