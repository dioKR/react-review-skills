#!/usr/bin/env bash
set -euo pipefail

BASE_REF="${1:-}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a git repository." >&2
  exit 1
fi

if [[ -z "$BASE_REF" ]]; then
  if git rev-parse --verify '@{upstream}' >/dev/null 2>&1; then
    BASE_REF="$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}')"
  else
    BASE_REF="origin/main"
  fi
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

echo "== Framework Detection =="
if [[ -f "package.json" ]]; then
  # Next.js detection
  if grep -q '"next"' package.json 2>/dev/null; then
    NEXT_VER=$(grep -o '"next"[[:space:]]*:[[:space:]]*"[^"]*"' package.json | grep -o '[0-9][^"]*' | head -1)
    echo "- Next.js: ${NEXT_VER:-detected}"

    # App Router vs Pages Router
    if [[ -d "app" ]]; then
      echo "- Router: App Router (app/)"
    elif [[ -d "src/app" ]]; then
      echo "- Router: App Router (src/app/)"
    elif [[ -d "pages" ]] || [[ -d "src/pages" ]]; then
      echo "- Router: Pages Router"
    fi
  else
    echo "- Next.js: not detected"
  fi

  # React version
  if grep -q '"react"' package.json 2>/dev/null; then
    REACT_VER=$(grep -o '"react"[[:space:]]*:[[:space:]]*"[^"]*"' package.json | grep -o '[0-9][^"]*' | head -1)
    echo "- React: ${REACT_VER:-detected}"
  fi
else
  echo "- package.json: not found"
fi
echo

echo "== Lint Tool Detection =="
if [[ -f "biome.json" || -f "biome.jsonc" ]]; then
  echo "- Biome: detected"
else
  echo "- Biome: not detected"
fi

if ls eslint.config.* .eslintrc* >/dev/null 2>&1; then
  echo "- ESLint: detected"
  # Check for jsx-a11y
  if grep -rq "jsx-a11y" eslint.config.* .eslintrc* 2>/dev/null; then
    echo "- jsx-a11y: detected"
  fi
else
  echo "- ESLint: not detected"
fi

if [[ -f "tsconfig.json" ]]; then
  echo "- TypeScript: detected"
fi
echo

echo "== Changed File Patterns =="
CHANGED_FILES=$(git diff --name-only "$RANGE" 2>/dev/null || true)

# Count by category
COMPONENT_COUNT=$(echo "$CHANGED_FILES" | grep -cE '\.(tsx|jsx)$' || echo 0)
HOOK_COUNT=$(echo "$CHANGED_FILES" | grep -cE 'use[A-Z].*\.(ts|tsx|js|jsx)$' || echo 0)
TEST_COUNT=$(echo "$CHANGED_FILES" | grep -cE '\.(test|spec)\.(ts|tsx|js|jsx)$' || echo 0)
STYLE_COUNT=$(echo "$CHANGED_FILES" | grep -cE '\.(css|scss|module\.css)$' || echo 0)
API_COUNT=$(echo "$CHANGED_FILES" | grep -cE 'api/|route\.(ts|js)$' || echo 0)

echo "- Components (tsx/jsx): $COMPONENT_COUNT"
echo "- Hooks (use*.ts): $HOOK_COUNT"
echo "- Tests: $TEST_COUNT"
echo "- Styles: $STYLE_COUNT"
echo "- API routes: $API_COUNT"
echo

# Check for 'use client' in changed files
echo "== Client Component Detection =="
USE_CLIENT_FILES=$(git diff "$RANGE" --name-only -z -- '*.tsx' '*.jsx' 2>/dev/null | xargs -0 grep -l "'use client'" 2>/dev/null || true)
if [[ -n "$USE_CLIENT_FILES" ]]; then
  echo "Files with 'use client':"
  echo "$USE_CLIENT_FILES" | sed 's/^/  - /'
else
  echo "- No 'use client' directives in changed files"
fi
echo

# Show high-impact files (large diffs)
echo "== High-Impact Files (>50 lines changed) =="
git diff --stat "$RANGE" 2>/dev/null | grep -E '\|\s+[5-9][0-9]\s+' | head -10 || echo "- None"
git diff --stat "$RANGE" 2>/dev/null | grep -E '\|\s+[0-9]{3,}\s+' | head -10 || true
