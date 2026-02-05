#!/usr/bin/env sh
set -eu

usage() {
  cat <<'EOF'
Usage: list-skills.sh [--user|--repo|--path <dir>] [--agents]

  --user        List user scope skills (default)
                - default: $CODEX_HOME/skills (legacy-compatible)
                - with --agents: ~/.agents/skills (Codex docs default)
  --repo        List repo scope skills (from current directory)
                - default: <git-root>/.codex/skills
                - with --agents: <git-root>/.agents/skills
  --path <dir>  List skills from an explicit skills directory
  --agents      Use .agents/skills locations for --user/--repo
EOF
}

scope="user"
custom_dest=""
use_agents="false"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --user)
      scope="user"
      ;;
    --repo)
      scope="repo"
      ;;
    --agents)
      use_agents="true"
      ;;
    --path)
      shift
      if [ -z "${1:-}" ]; then
        echo "Error: --path requires a directory." >&2
        usage >&2
        exit 1
      fi
      custom_dest="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [ -n "$custom_dest" ]; then
  skills_dir="$custom_dest"
elif [ "$scope" = "repo" ]; then
  if command -v git >/dev/null 2>&1 && git -C "$PWD" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    repo_root=$(git -C "$PWD" rev-parse --show-toplevel)
    if [ "$use_agents" = "true" ]; then
      skills_dir="$repo_root/.agents/skills"
    else
      skills_dir="$repo_root/.codex/skills"
    fi
  else
    echo "Error: not inside a git repo. Use --path or run inside a repo." >&2
    exit 1
  fi
else
  if [ "$use_agents" = "true" ]; then
    skills_dir="$HOME/.agents/skills"
  else
    dest_root="${CODEX_HOME:-$HOME/.codex}"
    skills_dir="$dest_root/skills"
  fi
fi

if [ ! -d "$skills_dir" ]; then
  echo "Skills dir not found: $skills_dir"
  exit 1
fi

find "$skills_dir" -maxdepth 2 -mindepth 2 -type f -name "SKILL.md" -exec dirname {} \; 2>/dev/null \
  | while IFS= read -r dir; do basename "$dir"; done \
  | sort -u
