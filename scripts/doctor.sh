#!/usr/bin/env sh
set -eu

echo "VC Skills Doctor"

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
  repo_dir="${VC_SKILLS_HOME:-${VS_SKILLS_HOME:-${VIBE_SKILLS_HOME:-$HOME/.vc-skills}}}"
  echo "Repo not found at: $repo_dir"
  echo "Tip: set VC_SKILLS_HOME (or legacy VS_SKILLS_HOME/VIBE_SKILLS_HOME) or run the bootstrap one-liner."
fi

if [ -d "$skills_dir/vc-router" ]; then
  echo "Core skill present: vc-router"
else
  echo "Core skill missing: vc-router"
fi

echo "Next: copy/paste into Codex chat:"
legacy_skills=$(find "$skills_dir" -maxdepth 1 -mindepth 1 -type d \( -name "vibe-*" -o -name "vs-*" -o -name "vf" -o -name "vg" -o -name "vsf" -o -name "vsg" \) -exec basename {} \; | tr '\n' ' ' | sed 's/ $//')
if [ -n "$legacy_skills" ]; then
  echo "Warning: legacy vibe/vs skills detected: $legacy_skills"
  echo "Tip: remove or rename legacy skills to avoid conflicts."
fi
echo "use vcg: build a login page"
echo "Tip: use \"use vcf: ...\" for end-to-end (plan/execute/test)."
