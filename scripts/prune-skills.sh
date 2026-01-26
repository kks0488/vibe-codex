#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
skills_repo_root=$(cd "$script_dir/.." && pwd)
src_dir="$skills_repo_root/skills"
core_skills_file="$script_dir/core-skills.txt"

usage() {
  cat <<'EOF'
Usage: prune-skills.sh [--user|--repo|--path <dir>] [--dry-run]

Removes (backs up) bundled non-core vibe-codex skills from the destination skills directory.
Only affects skills that exist in this repo's skills/ folder.

  --user        Use $CODEX_HOME/skills (default)
  --repo        Use <git-root>/.codex/skills (from current directory)
  --path <dir>  Use an explicit skills directory
  --dry-run     Print what would change, but don't move anything
EOF
}

if [ ! -f "$core_skills_file" ]; then
  echo "Error: missing core skills list: $core_skills_file" >&2
  exit 1
fi

scope="user"
custom_dest=""
dry_run="false"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --user)
      scope="user"
      ;;
    --repo)
      scope="repo"
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
    --dry-run)
      dry_run="true"
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
    dest_dir="$repo_root/.codex/skills"
  else
    echo "Error: not inside a git repo. Use --path or run inside a repo." >&2
    exit 1
  fi
else
  dest_root="${CODEX_HOME:-$HOME/.codex}"
  dest_dir="$dest_root/skills"
fi

if [ ! -d "$dest_dir" ]; then
  echo "Skills dir not found: $dest_dir" >&2
  exit 1
fi

timestamp=$(date +"%Y%m%d%H%M%S")
backup_dir=""
removed=0

for skill in "$src_dir"/*; do
  [ -d "$skill" ] || continue
  name=$(basename "$skill")

  if grep -Fxq "$name" "$core_skills_file"; then
    continue
  fi

  dest="$dest_dir/$name"
  if [ ! -e "$dest" ]; then
    continue
  fi

  if [ "$dry_run" = "true" ]; then
    echo "Would move: $dest"
    removed=$((removed + 1))
    continue
  fi

  if [ -z "$backup_dir" ]; then
    backup_dir="$dest_dir/.bak-$timestamp"
    mkdir -p "$backup_dir"
  fi
  mv "$dest" "$backup_dir/$name"
  removed=$((removed + 1))
done

if [ "$dry_run" = "true" ]; then
  echo "Dry run complete. Would remove $removed skill(s) from $dest_dir."
  exit 0
fi

echo "Removed $removed skill(s) from $dest_dir (non-core only)."
if [ -n "$backup_dir" ]; then
  echo "Backup dir: $backup_dir"
fi

