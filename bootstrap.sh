#!/usr/bin/env sh
set -eu

repo_url="https://github.com/kks0488/vibe-skills.git"
dest="${VIBE_SKILLS_HOME:-$HOME/.vibe-skills}"

if command -v git >/dev/null 2>&1; then
  if [ -d "$dest/.git" ]; then
    git -C "$dest" pull --ff-only
  else
    git clone "$repo_url" "$dest"
  fi
else
  echo "git is required. Install git first and re-run." >&2
  exit 1
fi

sh "$dest/scripts/install-skills.sh"
