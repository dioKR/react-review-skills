#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

INSTALL_ROOT="${RRS_HOME:-$HOME/.local/share/react-review-skills}"
BIN_DIR="${RRS_BIN:-$HOME/.local/bin}"

mkdir -p "$INSTALL_ROOT" "$BIN_DIR"

if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete --exclude '.git/' "$SOURCE_DIR/" "$INSTALL_ROOT/"
else
  rm -rf "$INSTALL_ROOT"
  mkdir -p "$INSTALL_ROOT"
  cp -R "$SOURCE_DIR"/. "$INSTALL_ROOT"/
  rm -rf "$INSTALL_ROOT/.git"
fi

cat > "$BIN_DIR/react-review-codex" <<EOF
#!/usr/bin/env bash
set -euo pipefail
"$INSTALL_ROOT/scripts/review-local.sh" --agent codex "\$@"
EOF

cat > "$BIN_DIR/react-review-claude" <<EOF
#!/usr/bin/env bash
set -euo pipefail
"$INSTALL_ROOT/scripts/review-local.sh" --agent claude "\$@"
EOF

chmod +x "$BIN_DIR/react-review-codex" "$BIN_DIR/react-review-claude" "$INSTALL_ROOT"/scripts/*.sh 2>/dev/null || true

echo "Installed review pack: $INSTALL_ROOT"
echo "Installed commands:"
echo "- $BIN_DIR/react-review-codex"
echo "- $BIN_DIR/react-review-claude"
echo
echo "Default base ref: current branch upstream (auto)."
echo "You can override: react-review-codex <base-ref>"
echo
echo "If '$BIN_DIR' is not in PATH, add:"
echo "export PATH=\"$BIN_DIR:\$PATH\""
