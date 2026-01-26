#!/usr/bin/env sh
set -eu

dest_root="${CODEX_HOME:-$HOME/.codex}"
skills_dir="$dest_root/skills"

if [ ! -d "$skills_dir" ]; then
  echo "Skills dir not found: $skills_dir"
  exit 1
fi

find "$skills_dir" -maxdepth 2 -mindepth 2 -type f -name "SKILL.md" -exec dirname {} \; 2>/dev/null \
  | while IFS= read -r dir; do basename "$dir"; done \
  | sort -u
