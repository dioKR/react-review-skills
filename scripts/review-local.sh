#!/usr/bin/env bash
set -euo pipefail

AGENT="codex"
BASE_REF=""
BASE_SET="false"
FOCUS_FILES=()

print_usage() {
  cat <<'EOF'
Usage:
  review-local.sh [base-ref] [focus files...]
  review-local.sh --agent <codex|claude> [base-ref] [focus files...]
  review-local.sh --base <base-ref> [--agent <codex|claude>] [focus files...]
  (no base-ref: auto-detect current branch upstream)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent)
      AGENT="${2:-}"
      shift 2
      ;;
    --agent=*)
      AGENT="${1#*=}"
      shift
      ;;
    --base)
      BASE_REF="${2:-}"
      BASE_SET="true"
      shift 2
      ;;
    --base=*)
      BASE_REF="${1#*=}"
      BASE_SET="true"
      shift
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    *)
      if [[ "$BASE_SET" == "false" ]]; then
        BASE_REF="$1"
        BASE_SET="true"
      else
        FOCUS_FILES+=("$1")
      fi
      shift
      ;;
  esac
done

if [[ "$AGENT" != "codex" && "$AGENT" != "claude" ]]; then
  echo "Unsupported agent: $AGENT (use codex or claude)" >&2
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Run this in the project you want to review (git repository)." >&2
  exit 1
fi

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -n "$BASE_REF" ]]; then
  "$SKILL_DIR/scripts/collect-pr-context.sh" "$BASE_REF"
else
  "$SKILL_DIR/scripts/collect-pr-context.sh"
fi

echo
if [[ "$AGENT" == "codex" ]]; then
  echo "== Prompt To Paste In Codex =="
  echo "\$react-review-skills로 리뷰해줘."
  if [[ -n "$BASE_REF" ]]; then
    echo "기준 브랜치: $BASE_REF"
  fi
else
  echo "== Prompt To Paste In Claude Code =="
  echo "Use \`$SKILL_DIR/CLAUDE.md\` as the execution guide."
  echo "Treat \`$SKILL_DIR/SKILL.md\` as source of truth."
  echo "Use these templates:"
  echo "- \`$SKILL_DIR/assets/templates/pr-review-comment.md\`"
  echo "- \`$SKILL_DIR/assets/templates/pr-summary.md\`"
  if [[ -n "$BASE_REF" ]]; then
    echo "Review this repo against base ref: $BASE_REF"
  else
    echo "Review this repo against the current branch upstream."
  fi
fi

if [[ ${#FOCUS_FILES[@]} -gt 0 ]]; then
  echo "중점 파일: ${FOCUS_FILES[*]}"
fi
