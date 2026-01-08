#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(cd "$script_dir/.." && pwd)

cmd="${1:-help}"
shift 2>/dev/null || true

case "$cmd" in
  install)
    sh "$repo_root/scripts/install-skills.sh"
    ;;
  update)
    sh "$repo_root/scripts/update-skills.sh"
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
  prompts)
    sh "$repo_root/scripts/role-prompts.sh" "${1:-all}"
    ;;
  go|finish)
    if [ -z "${1:-}" ]; then
      echo "Usage: vibe $cmd <goal>" >&2
      echo "Example: vibe $cmd build a login page" >&2
      echo "Tip: include a goal so Codex doesn't have to ask for one." >&2
      exit 1
    fi
    echo "Copy/paste into Codex chat:" >&2
    if [ "$cmd" = "go" ]; then
      echo "use vg: $*"
    else
      echo "use vf: $*"
    fi
    ;;
  sync)
    if [ "$#" -lt 1 ]; then
      echo "Usage: vibe sync <host> [host...]" >&2
      exit 1
    fi
    sh "$repo_root/scripts/update-skills.sh"
    for host in "$@"; do
      echo "Updating $host"
      ssh "$host" 'curl -fsSL https://raw.githubusercontent.com/kks0488/vibe-skills/main/bootstrap.sh | bash'
    done
    ;;
  help|*)
    cat <<'EOF'
vibe commands:
  install    install skills into ~/.codex/skills
  update     pull repo + reinstall skills
  doctor     check install status
  list       list installed skills
  scope      create a .vibe-scope in the current directory
  uninstall  remove skills (backup)
  prompts    print author/reviewer prompts
  go         router mode (prints "use vg: ...")
  finish     end-to-end mode (prints "use vf: ...")
  sync       update local + remote host(s)
EOF
    ;;
esac
