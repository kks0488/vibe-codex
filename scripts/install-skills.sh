#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(cd "$script_dir/.." && pwd)
src_dir="$repo_root/skills"

dest_root="${CODEX_HOME:-$HOME/.codex}"
dest_dir="$dest_root/skills"

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
legacy_skills=$(find "$dest_dir" -maxdepth 1 -mindepth 1 -type d \( -name "vibe-*" -o -name "vf" -o -name "vg" \) -printf "%f " | sed 's/ $//')
if [ -n "$legacy_skills" ]; then
  echo "Warning: legacy vibe skills detected: $legacy_skills"
  echo "Tip: remove or rename legacy skills to avoid conflicts."
fi
echo "use vsg: build a login page"
echo "Tip: use \"use vsf: ...\" for end-to-end (plan/execute/test)."
