#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(cd "$script_dir/.." && pwd)

cmd="${1:-help}"
shift 2>/dev/null || true

case "$cmd" in
  install)
    sh "$repo_root/scripts/install-skills.sh" "$@"
    ;;
  update)
    sh "$repo_root/scripts/update-skills.sh" "$@"
    ;;
  doctor)
    sh "$repo_root/scripts/doctor.sh"
    ;;
  list)
    sh "$repo_root/scripts/list-skills.sh"
    ;;
  scope)
    sh "$repo_root/scripts/scope-init.sh" "$@"
    ;;
  uninstall)
    sh "$repo_root/scripts/uninstall-skills.sh"
    ;;
  prune)
    sh "$repo_root/scripts/prune-skills.sh" "$@"
    ;;
  prompts)
    sh "$repo_root/scripts/role-prompts.sh" "${1:-all}"
    ;;
  mcp)
    sub="${1:-help}"
    shift 2>/dev/null || true

    case "$sub" in
      docs|devdocs)
        if ! command -v codex >/dev/null 2>&1; then
          echo "Error: codex not found in PATH." >&2
          echo "Install Codex CLI, then re-run." >&2
          echo "Docs MCP: codex mcp add openaiDeveloperDocs --url https://developers.openai.com/mcp" >&2
          exit 1
        fi
        codex mcp add openaiDeveloperDocs --url https://developers.openai.com/mcp
        ;;
      skills|vibes|vibe)
        if ! command -v codex >/dev/null 2>&1; then
          echo "Error: codex not found in PATH." >&2
          echo "Install Codex CLI, then re-run." >&2
          echo "vibe skills MCP: codex mcp add vibeSkills -- npx -y @kyoungsookim/skills-mcp-server" >&2
          exit 1
        fi
        codex mcp add vibeSkills -- npx -y @kyoungsookim/skills-mcp-server
        ;;
      list)
        if ! command -v codex >/dev/null 2>&1; then
          echo "Error: codex not found in PATH." >&2
          echo "Install Codex CLI, then re-run." >&2
          exit 1
        fi
        codex mcp list
        ;;
      help|*)
        cat <<'EOF'
vc mcp commands:
  vc mcp docs     add OpenAI developer docs MCP server
  vc mcp skills   add vibe skills MCP server (npx)
  vc mcp list     list configured MCP servers
EOF
        ;;
    esac
    ;;
  go|finish)
    if [ -z "${1:-}" ]; then
      echo "Usage: vc $cmd <goal>" >&2
      echo "Example: vc $cmd build a login page" >&2
      echo "Tip: include a goal so Codex doesn't have to ask for one." >&2
      exit 1
    fi
    echo "Copy/paste into Codex chat:" >&2
    if [ "$cmd" = "go" ]; then
      echo "use vcg: $*"
    else
      echo "use vcf: $*"
    fi
    ;;
  sync)
    if [ "$#" -lt 1 ]; then
      echo "Usage: vc sync <host> [host...]" >&2
      exit 1
    fi
    sh "$repo_root/scripts/update-skills.sh"
    for host in "$@"; do
      echo "Updating $host"
      ssh "$host" 'curl -fsSL https://raw.githubusercontent.com/kks0488/vibe-codex/main/bootstrap.sh | bash'
    done
    ;;
  help|*)
    cat <<'EOF'
vc commands:
  install    install vc skills (supports --repo/--path)
  update     pull repo + reinstall skills (supports --repo/--path)
  doctor     check install status
  list       list installed skills
  mcp        manage Codex MCP servers (docs/skills)
  scope      manage .vc-scope (create/add/show)
  uninstall  remove skills (backup)
  prune      remove legacy removed skills (backup)
  prompts    print author/reviewer prompts
  go         router mode (prints "use vcg: ...")
  finish     end-to-end mode (prints "use vcf: ...")
  sync       update local + remote host(s)
EOF
    ;;
esac
