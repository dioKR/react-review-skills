#!/usr/bin/env bash
set -euo pipefail

BASE_REF="${1:-origin/main}"
shift || true
FOCUS_FILES=("$@")

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Run this in the project you want to review (git repository)." >&2
  exit 1
fi

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"$SKILL_DIR/scripts/collect-pr-context.sh" "$BASE_REF"

echo
echo "== Prompt To Paste In Codex =="
echo "\$react-review-skills로 리뷰해줘."
echo "기준 브랜치: $BASE_REF"

if [[ ${#FOCUS_FILES[@]} -gt 0 ]]; then
  echo "중점 파일: ${FOCUS_FILES[*]}"
fi
