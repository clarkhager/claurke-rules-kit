#!/bin/bash
# check-updates.sh - Pull latest claurke-rules-kit and offer to redeploy
# Usage: bash check-updates.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

cd "$SCRIPT_DIR"

if [ ! -d ".git" ]; then
  echo "Not a git repository. Clone the kit via 'gh repo clone clarkhager/claurke-rules-kit ~/.claude/rules-kit' first."
  exit 1
fi

echo -e "${BLUE}>${NC} Checking for updates..."
git fetch origin --quiet

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse '@{u}' 2>/dev/null || git rev-parse origin/main)

if [ "$LOCAL" = "$REMOTE" ]; then
  echo -e "${GREEN}✓${NC} Already up to date ($LOCAL)"
  exit 0
fi

echo -e "${YELLOW}!${NC} Updates available."
echo ""
echo "Commits to be applied:"
git --no-pager log --oneline "$LOCAL".."$REMOTE"
echo ""
read -rp "Pull and apply? [Y/n]: " PULL
if [[ "${PULL:-Y}" =~ ^[Yy]$ ]]; then
  git pull --ff-only origin main
  echo ""
  echo -e "${GREEN}✓${NC} Pulled latest."
  echo ""
  read -rp "Redeploy to global (~/.claude/)? [Y/n]: " REDEPLOY
  if [[ "${REDEPLOY:-Y}" =~ ^[Yy]$ ]]; then
    bash "$SCRIPT_DIR/deploy.sh" --global
  else
    echo "Skipped redeploy. Run 'bash deploy.sh' manually when ready."
  fi
fi
