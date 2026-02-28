#!/usr/bin/env bash
# Runs ESLint --fix on Angular files after Claude writes or edits them.
# Receives hook input as JSON on stdin; uses jq to extract the file path.

set -euo pipefail

# Extract file path from hook JSON input
FILE_PATH=$(cat /dev/stdin | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Exit silently if no file path (tool doesn't involve a file)
if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Only act on Angular file types
case "$FILE_PATH" in
  *.ts|*.html|*.scss|*.css)
    ;;
  *)
    exit 0
    ;;
esac

# Skip non-existent files
if [[ ! -f "$FILE_PATH" ]]; then
  exit 0
fi

# Skip node_modules and dist
if [[ "$FILE_PATH" == *"node_modules"* ]] || [[ "$FILE_PATH" == *"/dist/"* ]]; then
  exit 0
fi

# Find the project root (directory containing package.json)
PROJECT_ROOT=$(dirname "$FILE_PATH")
while [[ "$PROJECT_ROOT" != "/" && ! -f "$PROJECT_ROOT/package.json" ]]; do
  PROJECT_ROOT=$(dirname "$PROJECT_ROOT")
done

if [[ "$PROJECT_ROOT" == "/" ]]; then
  exit 0
fi

# Run ESLint --fix if available
if command -v npx &>/dev/null && [[ -f "$PROJECT_ROOT/.eslintrc.json" || -f "$PROJECT_ROOT/eslint.config.js" || -f "$PROJECT_ROOT/eslint.config.mjs" ]]; then
  npx eslint --fix "$FILE_PATH" --quiet 2>/dev/null || true
fi

# Run Prettier if available and applicable
if [[ "$FILE_PATH" == *.ts || "$FILE_PATH" == *.html || "$FILE_PATH" == *.scss ]]; then
  if command -v npx &>/dev/null && [[ -f "$PROJECT_ROOT/.prettierrc" || -f "$PROJECT_ROOT/.prettierrc.json" || -f "$PROJECT_ROOT/prettier.config.js" ]]; then
    npx prettier --write "$FILE_PATH" --log-level silent 2>/dev/null || true
  fi
fi
