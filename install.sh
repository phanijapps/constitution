#!/usr/bin/env bash
# constitution installer — copies the skill to your coding agent's location.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$REPO_DIR/skill"
SKILL_NAME="constitution"

if [ ! -d "$SKILL_DIR" ]; then
  echo "error: skill/ not found in $REPO_DIR" >&2; exit 1
fi

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║   constitution — installer               ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""
echo "  Select your coding agent:"
echo ""
echo "  1) Claude Code     (~/.claude/skills/)"
echo "  2) Codex           (~/.agents/skills/)"
echo "  3) Cursor          (~/.cursor/skills/)"
echo "  4) GitHub Copilot  (.github/skills/ in current repo)"
echo "  5) Generic         (~/.agents/skills/ — shared with Codex)"
echo "  6) All (Claude + Codex + Cursor)"
echo ""
read -rp "  Enter number [1-6]: " choice
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
  5) install_to "$HOME/.agents/skills" ;;
  6)
    install_to "$HOME/.claude/skills"
    install_to "$HOME/.agents/skills"
    install_to "$HOME/.cursor/skills"
    ;;
  *) echo "  invalid choice: $choice" >&2; exit 1 ;;
esac

echo ""
echo "  Done. Verify with:"
case "$choice" in
  1) echo "    python3 ~/.claude/skills/constitution/scripts/scaffold.py --help" ;;
  2) echo "    python3 ~/.agents/skills/constitution/scripts/scaffold.py --help" ;;
  3) echo "    python3 ~/.cursor/skills/constitution/scripts/scaffold.py --help" ;;
  4) echo "    python3 .github/skills/constitution/scripts/scaffold.py --help" ;;
  5) echo "    python3 ~/.agents/skills/constitution/scripts/scaffold.py --help" ;;
  6) echo "    python3 ~/.claude/skills/constitution/scripts/scaffold.py --help" ;;
esac
echo ""
