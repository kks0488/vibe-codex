#!/usr/bin/env sh
set -eu

scope_file="$PWD/.vibe-scope"

if [ -f "$scope_file" ]; then
  echo "Already exists: $scope_file"
  exit 0
fi

{
  echo "# Vibe scope roots"
  echo "# One path per line (relative to this file unless absolute)"
  if [ "$#" -eq 0 ]; then
    echo "."
  else
    for p in "$@"; do
      echo "$p"
    done
  fi
} > "$scope_file"

echo "Created $scope_file"
