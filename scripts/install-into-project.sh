#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <target-project-path> [skill-repo-url]" >&2
  exit 1
fi

TARGET_PROJECT="$(cd "$1" && pwd)"
SKILL_REPO_URL="${2:-https://github.com/dioKR/react-review-skills.git}"
WORKFLOW_DIR="$TARGET_PROJECT/.github/workflows"
WORKFLOW_PATH="$WORKFLOW_DIR/react-review-command.yml"
TEMPLATE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/assets/templates/project/workflows/react-review-command.yml"

if ! git -C "$TARGET_PROJECT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Target must be a git repository: $TARGET_PROJECT" >&2
  exit 1
fi

mkdir -p "$WORKFLOW_DIR"
sed "s|__SKILL_REPO__|$SKILL_REPO_URL|g" "$TEMPLATE_PATH" > "$WORKFLOW_PATH"

echo "Installed workflow: $WORKFLOW_PATH"
echo
echo "Next setup in target repo:"
echo "1) Add Actions secret: OPENAI_API_KEY"
echo "2) (Optional) Add Actions variable: OPENAI_MODEL (default: gpt-5-mini)"
echo "3) (Optional) Add Actions variable: REACT_REVIEW_REQUIRE_BOT_PR=true"
echo "4) Commit and push this workflow"
echo "5) In a PR comment, run: /react-review"
