#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
TARGET_DIR="$CODEX_HOME_DIR/skills/react-review-skills"

mkdir -p "$(dirname "$TARGET_DIR")"

if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete --exclude '.git/' "$SOURCE_DIR/" "$TARGET_DIR/"
else
  rm -rf "$TARGET_DIR"
  mkdir -p "$TARGET_DIR"
  cp -R "$SOURCE_DIR"/. "$TARGET_DIR"/
  rm -rf "$TARGET_DIR/.git"
fi

chmod +x "$TARGET_DIR"/scripts/*.sh 2>/dev/null || true

echo "Installed: $TARGET_DIR"
echo
echo "Next steps:"
echo "1) Move to a React/Next project (git repo)."
echo "2) Codex:  $TARGET_DIR/scripts/review-local.sh origin/main"
echo "3) Claude: $TARGET_DIR/scripts/review-local-claude.sh origin/main"
echo "4) Paste the printed prompt into your agent."
