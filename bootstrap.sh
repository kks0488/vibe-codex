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

bin_dir="${XDG_BIN_DIR:-}"
if [ -z "$bin_dir" ]; then
  if [ -d "$HOME/.local/bin" ] || mkdir -p "$HOME/.local/bin"; then
    bin_dir="$HOME/.local/bin"
  elif [ -d "$HOME/bin" ] || mkdir -p "$HOME/bin"; then
    bin_dir="$HOME/bin"
  fi
fi

if [ -n "${bin_dir:-}" ]; then
  wrapper="$bin_dir/vibe"
  printf '#!/usr/bin/env sh\nexec sh "%s/scripts/vibe.sh" "$@"\n' "$dest" > "$wrapper"
  chmod +x "$wrapper"
  echo "Command installed: vibe"
  case ":$PATH:" in
    *":$bin_dir:"*) ;;
    *) echo "Tip: add $bin_dir to PATH if 'vibe' is not found." ;;
  esac
else
  echo "Tip: run 'bash $dest/scripts/vibe.sh <command>' for shortcuts."
fi
