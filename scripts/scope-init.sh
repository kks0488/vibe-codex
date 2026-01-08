#!/usr/bin/env sh
set -eu

scope_file="$PWD/.vibe-scope"
cmd="${1:-init}"

write_header() {
  echo "# Vibe scope roots"
  echo "# One path per line (relative to this file unless absolute)"
}

init_scope() {
  if [ -f "$scope_file" ]; then
    echo "Already exists: $scope_file"
    exit 0
  fi
  {
    write_header
    if [ "$#" -eq 0 ]; then
      echo "."
    else
      for p in "$@"; do
        [ -n "$p" ] || continue
        echo "$p"
      done
    fi
  } > "$scope_file"
  echo "Created $scope_file"
}

add_scope() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: vibe scope add <path> [path...]" >&2
    exit 1
  fi
  if [ ! -f "$scope_file" ]; then
    write_header > "$scope_file"
  fi
  for p in "$@"; do
    [ -n "$p" ] || continue
    if ! grep -Fxq "$p" "$scope_file"; then
      echo "$p" >> "$scope_file"
    fi
  done
  echo "Updated $scope_file"
}

show_scope() {
  if [ ! -f "$scope_file" ]; then
    echo "Not found: $scope_file" >&2
    exit 1
  fi
  cat "$scope_file"
}

case "$cmd" in
  add)
    shift
    add_scope "$@"
    ;;
  show)
    show_scope
    ;;
  init|create)
    shift
    init_scope "$@"
    ;;
  *)
    init_scope "$@"
    ;;
esac
