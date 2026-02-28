#!/usr/bin/env bash
# Sets up local git hooks for this repo.
# Run once after cloning: bash scripts/install-hooks.sh

set -euo pipefail

HOOKS_DIR="$(git rev-parse --show-toplevel)/.git/hooks"
REPO_ROOT="$(git rev-parse --show-toplevel)"

echo "Installing git hooks..."

# commit-msg: validates commit message format
cat > "$HOOKS_DIR/commit-msg" << 'EOF'
#!/usr/bin/env bash
node "$(git rev-parse --show-toplevel)/commit-message-hook.js" "$1"
EOF

chmod +x "$HOOKS_DIR/commit-msg"

echo "✓ commit-msg hook installed"
echo ""
echo "Commit format: type(scope): description"
echo "Example:       feat(skills): add angular-signals skill"
echo ""
echo "Done. Run 'bash scripts/install-hooks.sh' again after pulling to stay up to date."
