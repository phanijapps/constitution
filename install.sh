#!/usr/bin/env bash
# constitution installer — works piped from curl OR run locally after clone.
#
# Remote:   curl -fsSL https://raw.githubusercontent.com/phanijapps/constitution/main/install.sh | bash
# Local:    git clone https://github.com/phanijapps/constitution && cd constitution && ./install.sh
set -euo pipefail

REPO_URL="https://github.com/phanijapps/constitution"
SKILL_NAME="constitution"

# Detect mode: piped (stdin is not a tty) vs local (script file exists)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"
TEMP_DIR=""

if [ -n "$SCRIPT_DIR" ] && [ -d "$SCRIPT_DIR/skill" ]; then
  SKILL_DIR="$SCRIPT_DIR/skill"
  MODE="local"
else
  # Piped mode: clone sparsely to temp
  TEMP_DIR="$(mktemp -d)"
  cleanup() { rm -rf "$TEMP_DIR"; }
  trap cleanup EXIT
  if command -v git >/dev/null 2>&1; then
    git clone --depth 1 --filter=blob:none --sparse "$REPO_URL" "$TEMP_DIR" 2>/dev/null
    (cd "$TEMP_DIR" && git sparse-checkout set skill) 2>/dev/null
  else
    echo "  error: git is required for remote install" >&2; exit 1
  fi
  SKILL_DIR="$TEMP_DIR/skill"
  MODE="remote"
fi

if [ ! -d "$SKILL_DIR" ]; then
  echo "  error: skill/ not found" >&2; exit 1
fi

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║   constitution — installer ($MODE)        ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""
echo "  Select your coding agent:"
echo ""
echo "  1) Claude Code     (~/.claude/skills/)"
echo "  2) Codex           (~/.agents/skills/)"
echo "  3) Cursor          (~/.cursor/skills/)"
echo "  4) GitHub Copilot  (.github/skills/ in current repo)"
echo "  5) All (Claude + Codex + Cursor)"
echo ""
read -rp "  Enter number [1-5]: " choice
echo ""

install_to() {
  local dest="$1"
  mkdir -p "$dest"
  rm -rf "$dest/$SKILL_NAME"
  cp -r "$SKILL_DIR" "$dest/$SKILL_NAME"
  echo "  ✓ installed to $dest/$SKILL_NAME"
}

case "$choice" in
  1) install_to "$HOME/.claude/skills" ;;
  2) install_to "$HOME/.agents/skills" ;;
  3) install_to "$HOME/.cursor/skills" ;;
  4)
    read -rp "  Path to repo root (default: current dir): " repo
    repo="${repo:-$(pwd)}"
    install_to "$repo/.github/skills"
    ;;
  5)
    install_to "$HOME/.claude/skills"
    install_to "$HOME/.agents/skills"
    install_to "$HOME/.cursor/skills"
    ;;
  *) echo "  invalid choice: $choice" >&2; exit 1 ;;
esac

echo ""
echo "  Done. Verify with:"
case "$choice" in
  1) echo "    python3 ~/.claude/skills/$SKILL_NAME/scripts/scaffold.py --help" ;;
  2) echo "    python3 ~/.agents/skills/$SKILL_NAME/scripts/scaffold.py --help" ;;
  3) echo "    python3 ~/.cursor/skills/$SKILL_NAME/scripts/scaffold.py --help" ;;
  4) echo "    python3 .github/skills/$SKILL_NAME/scripts/scaffold.py --help" ;;
  5) echo "    python3 ~/.claude/skills/$SKILL_NAME/scripts/scaffold.py --help" ;;
esac
echo ""
