#!/usr/bin/env sh
set -eu

echo "VC Skills Doctor"

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
skills_repo_root=$(cd "$script_dir/.." && pwd)

user_root="${CODEX_HOME:-$HOME/.codex}"
user_skills_dir="$user_root/skills"

cwd=$(pwd)
cwd_skills_dir="$cwd/.codex/skills"
repo_root=""
repo_skills_dir=""

if command -v git >/dev/null 2>&1; then
  if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    repo_root=$(git -C "$cwd" rev-parse --show-toplevel)
    repo_root=$(printf "%s" "$repo_root" | tr -d '\r')
    repo_skills_dir="$repo_root/.codex/skills"
  fi
fi

echo "CODEX_HOME: $user_root"

count_dirs() {
  find "$1" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' '
}

validate_skill() {
  skill_dir="$1"
  skill_file="$skill_dir/SKILL.md"
  if [ ! -f "$skill_file" ]; then
    echo "WARN: missing SKILL.md: $skill_dir"
    return 1
  fi

  first_line=$(sed -n '1p' "$skill_file" | tr -d '\r')
  if [ "$first_line" != "---" ]; then
    echo "WARN: missing frontmatter: $skill_file"
    return 1
  fi

  frontmatter=$(awk 'NR==1{next} {gsub("\r", ""); if ($0=="---") {exit} print}' "$skill_file")
  name=$(printf "%s\n" "$frontmatter" | awk -F':' '$1 ~ /^[[:space:]]*name[[:space:]]*$/ { $1=""; sub(/^:/, "", $0); sub(/^[[:space:]]+/, "", $0); print; exit }')
  desc=$(printf "%s\n" "$frontmatter" | awk -F':' '$1 ~ /^[[:space:]]*description[[:space:]]*$/ { $1=""; sub(/^:/, "", $0); sub(/^[[:space:]]+/, "", $0); print; exit }')

  if [ -z "$name" ]; then
    echo "WARN: missing name: $skill_file"
    return 1
  fi
  if [ -z "$desc" ]; then
    echo "WARN: missing description: $skill_file"
    return 1
  fi

  name_len=$(printf "%s" "$name" | wc -c | tr -d ' ')
  desc_len=$(printf "%s" "$desc" | wc -c | tr -d ' ')

  if [ "$name_len" -gt 100 ]; then
    echo "WARN: name too long ($name_len > 100): $skill_file"
    return 1
  fi
  if [ "$desc_len" -gt 500 ]; then
    echo "WARN: description too long ($desc_len > 500): $skill_file"
    return 1
  fi

  return 0
}

validate_skills_dir() {
  dir="$1"
  label="$2"
  if [ ! -d "$dir" ]; then
    return 0
  fi

  echo "Checking skill metadata ($label): $dir"
  issues=0
  for skill in "$dir"/*; do
    [ -d "$skill" ] || continue
    if ! validate_skill "$skill"; then
      issues=$((issues + 1))
    fi
  done

  if [ "$issues" -eq 0 ]; then
    echo "Skill metadata OK ($label)"
  else
    echo "Skill metadata issues: $issues ($label)"
  fi
}

if [ -d "$user_skills_dir" ]; then
  count=$(count_dirs "$user_skills_dir")
  echo "Skills dir (user): $user_skills_dir ($count installed)"
else
  echo "Skills dir not found: $user_skills_dir"
fi

if [ -d "$cwd_skills_dir" ]; then
  count=$(count_dirs "$cwd_skills_dir")
  echo "Skills dir (repo cwd): $cwd_skills_dir ($count installed)"
fi

if [ -n "$repo_skills_dir" ] && [ "$repo_skills_dir" != "$cwd_skills_dir" ] && [ -d "$repo_skills_dir" ]; then
  count=$(count_dirs "$repo_skills_dir")
  echo "Skills dir (repo root): $repo_skills_dir ($count installed)"
fi

if [ -d "$skills_repo_root/.git" ]; then
  echo "Repo: $skills_repo_root"
  git -C "$skills_repo_root" rev-parse --abbrev-ref HEAD | awk '{print "Branch: " $0}'
  git -C "$skills_repo_root" rev-parse --short HEAD | awk '{print "Commit: " $0}'
  version_file="$skills_repo_root/VERSION"
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

core_skill=""
if [ -d "$user_skills_dir/vc-router" ]; then
  core_skill="$user_skills_dir"
elif [ -d "$cwd_skills_dir/vc-router" ]; then
  core_skill="$cwd_skills_dir"
elif [ -n "$repo_skills_dir" ] && [ -d "$repo_skills_dir/vc-router" ]; then
  core_skill="$repo_skills_dir"
fi

if [ -n "$core_skill" ]; then
  echo "Core skill present: vc-router ($core_skill)"
else
  echo "Core skill missing: vc-router"
fi

validate_skills_dir "$user_skills_dir" "user"
validate_skills_dir "$cwd_skills_dir" "repo-cwd"
if [ -n "$repo_skills_dir" ] && [ "$repo_skills_dir" != "$cwd_skills_dir" ]; then
  validate_skills_dir "$repo_skills_dir" "repo-root"
fi

echo "Next: copy/paste into Codex chat:"
legacy_skills=$(find "$user_skills_dir" -maxdepth 1 -mindepth 1 -type d \( -name "vibe-*" -o -name "vs-*" -o -name "vf" -o -name "vg" -o -name "vsf" -o -name "vsg" \) -exec basename {} \; 2>/dev/null | tr '\n' ' ' | sed 's/ $//')
if [ -n "$legacy_skills" ]; then
  echo "Warning: legacy vibe/vs skills detected: $legacy_skills"
  echo "Tip: remove or rename legacy skills to avoid conflicts."
fi
echo "use vcg: build a login page"
echo "Tip: use \"use vcf: ...\" for end-to-end (plan/execute/test)."
