#!/usr/bin/env sh
set -eu

echo "VS Skills Doctor"

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(cd "$script_dir/.." && pwd)

dest_root="${CODEX_HOME:-$HOME/.codex}"
skills_dir="$dest_root/skills"

echo "CODEX_HOME: $dest_root"

if [ -d "$skills_dir" ]; then
  count=$(find "$skills_dir" -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')
  echo "Skills dir: $skills_dir ($count installed)"
else
  echo "Skills dir not found: $skills_dir"
fi

if [ -d "$repo_root/.git" ]; then
  echo "Repo: $repo_root"
  git -C "$repo_root" rev-parse --abbrev-ref HEAD | awk '{print "Branch: " $0}'
  git -C "$repo_root" rev-parse --short HEAD | awk '{print "Commit: " $0}'
  version_file="$repo_root/VERSION"
  if [ -f "$version_file" ]; then
    version=$(tr -d ' \t\r\n' < "$version_file")
    if [ -n "$version" ]; then
      echo "Version: $version"
    fi
  fi
else
  repo_dir="${VS_SKILLS_HOME:-${VIBE_SKILLS_HOME:-$HOME/.vs-skills}}"
  echo "Repo not found at: $repo_dir"
  echo "Tip: set VS_SKILLS_HOME (or legacy VIBE_SKILLS_HOME) or run the bootstrap one-liner."
fi

if [ -d "$skills_dir/vs-router" ]; then
  echo "Core skill present: vs-router"
else
  echo "Core skill missing: vs-router"
fi

echo "Next: copy/paste into Codex chat:"
legacy_skills=$(find "$skills_dir" -maxdepth 1 -mindepth 1 -type d \( -name "vibe-*" -o -name "vf" -o -name "vg" \) -printf "%f " | sed 's/ $//')
if [ -n "$legacy_skills" ]; then
  echo "Warning: legacy vibe skills detected: $legacy_skills"
  echo "Tip: remove or rename legacy skills to avoid conflicts."
fi
echo "use vsg: build a login page"
echo "Tip: use \"use vsf: ...\" for end-to-end (plan/execute/test)."
