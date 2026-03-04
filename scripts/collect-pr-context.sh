#!/usr/bin/env bash
set -euo pipefail

BASE_REF="${1:-origin/main}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a git repository." >&2
  exit 1
fi

if git rev-parse --verify "$BASE_REF" >/dev/null 2>&1; then
  RANGE="$BASE_REF...HEAD"
else
  RANGE="HEAD~1...HEAD"
fi

echo "== PR Context =="
echo "Range: $RANGE"
echo

echo "== Changed Files =="
git diff --name-status "$RANGE"
echo

echo "== Diffstat =="
git diff --stat "$RANGE"
echo

echo "== Lint Tool Detection =="
if [[ -f "biome.json" || -f "biome.jsonc" ]]; then
  echo "- Biome: detected"
else
  echo "- Biome: not detected"
fi

if ls eslint.config.* .eslintrc* >/dev/null 2>&1; then
  echo "- ESLint: detected"
else
  echo "- ESLint: not detected"
fi
