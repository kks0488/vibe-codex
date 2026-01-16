#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
skills_repo_root=$(cd "$script_dir/.." && pwd)
src_dir="$skills_repo_root/skills"

usage() {
  cat <<'EOF'
Usage: install-skills.sh [--user|--repo|--path <dir>]

  --user        Install to $CODEX_HOME/skills (default)
  --repo        Install to <git-root>/.codex/skills (from current directory)
  --path <dir>  Install to an explicit skills directory
EOF
}

scope="user"
custom_dest=""
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

mkdir -p "$dest_dir"

timestamp=$(date +"%Y%m%d%H%M%S")
for skill in "$src_dir"/*; do
  [ -d "$skill" ] || continue
  name=$(basename "$skill")
  dest="$dest_dir/$name"
  if [ -e "$dest" ]; then
    mv "$dest" "$dest.bak-$timestamp"
  fi
  cp -R "$skill" "$dest"
done

echo "Installed skills to $dest_dir"
echo "Backup suffix (if any): .bak-$timestamp"
echo "Next: copy/paste into Codex chat:"
legacy_skills=$(find "$dest_dir" -maxdepth 1 -mindepth 1 -type d \( -name "vibe-*" -o -name "vs-*" -o -name "vf" -o -name "vg" -o -name "vsf" -o -name "vsg" \) -exec basename {} \; | tr '\n' ' ' | sed 's/ $//')
if [ -n "$legacy_skills" ]; then
  echo "Warning: legacy vibe/vs skills detected: $legacy_skills"
  echo "Tip: remove or rename legacy skills to avoid conflicts."
fi
echo "use vcg: build a login page"
echo "Tip: use \"use vcf: ...\" for end-to-end (plan/execute/test)."
