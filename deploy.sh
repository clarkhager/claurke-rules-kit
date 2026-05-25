#!/bin/bash
# deploy.sh - Install claurke-rules-kit globally or per-project
# Usage: bash deploy.sh [--global | --project DIR]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_DIR="$SCRIPT_DIR/rules"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() { echo -e "${BLUE}>${NC} $1"; }
print_ok()   { echo -e "${GREEN}✓${NC} $1"; }
print_warn() { echo -e "${YELLOW}!${NC} $1"; }

usage() {
  cat <<EOF
Usage: deploy.sh [--global | --project DIR]

Modes:
  --global              Install to ~/.claude/ (loaded by Claude Code globally;
                        for Cowork, paste contents into Settings > Global Instructions)
  --project DIR         Install to a specific project folder

With no arguments, runs interactively.
EOF
}

MODE=""
TARGET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global) MODE="global"; shift ;;
    --project) MODE="project"; TARGET="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1"; usage; exit 1 ;;
  esac
done

echo ""
echo "claurke-rules-kit deploy"
echo "========================"
echo ""

if [ -z "$MODE" ]; then
  echo "Install mode:"
  echo "  1) Global (~/.claude/ - loaded by Claude Code on every session)"
  echo "  2) Project folder (rules apply only within that folder)"
  read -rp "Choice [1/2]: " CHOICE
  case "$CHOICE" in
    1) MODE="global" ;;
    2) MODE="project"; read -rp "Project directory [$(pwd)]: " TARGET; TARGET="${TARGET:-$(pwd)}" ;;
    *) echo "Invalid choice"; exit 1 ;;
  esac
fi

if [ "$MODE" = "global" ]; then
  TARGET_DIR="$HOME/.claude"
elif [ "$MODE" = "project" ]; then
  if [ -z "$TARGET" ]; then
    read -rp "Project directory [$(pwd)]: " TARGET
    TARGET="${TARGET:-$(pwd)}"
  fi
  TARGET_DIR="$(realpath "$TARGET")"
fi

mkdir -p "$TARGET_DIR"

RULE_FILES=(
  "CLAUDE.md"
  "claude_voice_rules.md"
  "claude_anti_sycophancy.md"
  "claude_coding_rules.md"
  "claude_diagnostic_mode.md"
)

backup_file() {
  local f="$1"
  local ts
  ts="$(date +%Y%m%d-%H%M%S)"
  cp "$f" "$f.bak-$ts"
  print_warn "Backed up to $(basename "$f").bak-$ts"
}

echo ""
print_step "Deploying rules to $TARGET_DIR..."

for f in "${RULE_FILES[@]}"; do
  src="$RULES_DIR/$f"
  dst="$TARGET_DIR/$f"

  if [ ! -f "$src" ]; then
    print_warn "Source missing: $src (skipping)"
    continue
  fi

  if [ -f "$dst" ]; then
    if diff -q "$src" "$dst" > /dev/null 2>&1; then
      print_ok "$f (already up to date)"
    else
      read -rp "  $f exists and differs. Update with backup? [Y/n]: " UPD
      if [[ "${UPD:-Y}" =~ ^[Yy]$ ]]; then
        backup_file "$dst"
        cp "$src" "$dst"
        print_ok "$f (updated)"
      else
        print_warn "$f (kept existing)"
      fi
    fi
  else
    cp "$src" "$dst"
    print_ok "$f (installed)"
  fi
done

SHA=$(git -C "$SCRIPT_DIR" rev-parse --short HEAD 2>/dev/null || echo 'unknown')
echo "$(date +%Y-%m-%d) $SHA" > "$TARGET_DIR/.claurke-rules-kit"

# --- Humanizer skill prerequisite check ---
echo ""
print_step "Checking humanizer skill prerequisite..."

HUMANIZER_PATHS=(
  "$HOME/.claude/skills/humanizer"
  "$HOME/.claude/plugins/anthropic-skills/skills/humanizer"
  "$HOME/.claude/plugins/cache/anthropic-skills"
  "$HOME/Library/Application Support/Claude/skills/humanizer"
)

HUMANIZER_FOUND=false
FOUND_AT=""
for p in "${HUMANIZER_PATHS[@]}"; do
  if [ -d "$p" ] || [ -e "$p" ]; then
    HUMANIZER_FOUND=true
    FOUND_AT="$p"
    break
  fi
done

if [ "$HUMANIZER_FOUND" = true ]; then
  print_ok "humanizer detected at $FOUND_AT"
else
  print_warn "humanizer skill not detected at standard paths."
  echo ""
  echo "  The Voice rule in CLAUDE.md requires the humanizer skill."
  echo "  Without it installed, the voice-rule pass silently won't run."
  echo ""
  echo "  To install:"
  echo "    Cowork:      open Settings > Plugins, install the Anthropic Skills bundle"
  echo "    Claude Code: claude plugin install anthropic-skills"
  echo "                 (or place the skill at ~/.claude/skills/humanizer/)"
  echo ""
  echo "  Detection paths checked:"
  for p in "${HUMANIZER_PATHS[@]}"; do
    echo "    - $p"
  done
  echo ""
  echo "  If you've installed humanizer at a non-standard path, the kit still works;"
  echo "  this is just a heads-up that detection couldn't confirm it."
fi

echo ""
echo "========================"
echo -e "${GREEN}Deploy complete${NC}"
echo ""

if [ "$MODE" = "global" ]; then
  cat <<EOF
Installed to $TARGET_DIR

For Claude Code: rules load automatically from ~/.claude/CLAUDE.md.

For Cowork: this path is not auto-loaded by Cowork. To use these rules in Cowork:
  1. Open Cowork > Settings > Global Instructions
  2. Paste the contents of $TARGET_DIR/CLAUDE.md
  3. Save

Run the verification tests in docs/guide.md to confirm the rules are loaded.
EOF
else
  cat <<EOF
Installed to $TARGET_DIR

For Cowork: connect Cowork to this folder. CLAUDE.md will auto-load.

Run the verification tests in docs/guide.md to confirm the rules are loaded.
EOF
fi
echo ""
