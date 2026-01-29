# Codex CLI setup (recommended for vibe-codex)

## 1) Install vibe-codex skills

- One-liner (Mac/Linux): `curl -fsSL https://raw.githubusercontent.com/kks0488/vibe-codex/main/bootstrap.sh | bash`
- Or from this repo:
  - User scope: `bash scripts/install-skills.sh`
  - Repo scope (current git repo): `bash scripts/install-skills.sh --repo`
- Restart Codex after installing/updating skills.

## 2) Add OpenAI Developer Docs MCP (highly recommended)

- Via helper: `vc mcp docs`
- Or directly: `codex mcp add openaiDeveloperDocs --url https://developers.openai.com/mcp`
- Note: vibe-codex core skills declare this MCP server as a dependency in `SKILL.json`, so Codex may prompt to install it automatically.

Why: lets Codex pull official OpenAI/Codex/API docs into context without general web browsing.

## 3) (Optional) Enable useful Codex features

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

## 4) Verify

- `vc doctor`
