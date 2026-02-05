#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
core_skills_file="$script_dir/core-skills.txt"

usage() {
  cat <<'EOF'
Usage: uninstall-skills.sh [--user|--repo|--path <dir>] [--agents]

Removes (backs up) core vc skills from an installed skills directory.

  --user        Use user skills scope (default)
                - default: $CODEX_HOME/skills (legacy-compatible)
                - with --agents: ~/.agents/skills (Codex docs default)
  --repo        Use repo skills scope (from current directory)
                - default: <git-root>/.codex/skills
                - with --agents: <git-root>/.agents/skills
  --path <dir>  Use an explicit skills directory
  --agents      Use .agents/skills locations for --user/--repo
EOF
}

if [ ! -f "$core_skills_file" ]; then
  echo "Error: missing core skills list: $core_skills_file" >&2
  exit 1
fi

read_core_skills() {
  awk 'NF && $1 !~ /^#/' "$core_skills_file"
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
  dest_dir="$custom_dest"
elif [ "$scope" = "repo" ]; then
  if command -v git >/dev/null 2>&1 && git -C "$PWD" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    repo_root=$(git -C "$PWD" rev-parse --show-toplevel)
    if [ "$use_agents" = "true" ]; then
      dest_dir="$repo_root/.agents/skills"
    else
      dest_dir="$repo_root/.codex/skills"
    fi
  else
    echo "Error: not inside a git repo. Use --path or run inside a repo." >&2
    exit 1
  fi
else
  if [ "$use_agents" = "true" ]; then
    dest_dir="$HOME/.agents/skills"
  else
    dest_root="${CODEX_HOME:-$HOME/.codex}"
    dest_dir="$dest_root/skills"
  fi
fi

if [ ! -d "$dest_dir" ]; then
  echo "Skills dir not found: $dest_dir"
  exit 1
fi

timestamp=$(date +"%Y%m%d%H%M%S")
backup_dir=""
removed=0

for name in $(read_core_skills); do
  dest="$dest_dir/$name"
  if [ ! -e "$dest" ]; then
    continue
  fi
  if [ -z "$backup_dir" ]; then
    backup_dir="$(dirname "$dest_dir")/skills.bak-$timestamp"
    mkdir -p "$backup_dir"
  fi
  mv "$dest" "$backup_dir/$name"
  removed=$((removed + 1))
done

echo "Removed $removed skill(s)."
if [ -n "$backup_dir" ]; then
  echo "Backup dir: $backup_dir"
fi
