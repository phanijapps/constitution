#!/usr/bin/env bash
# Remote installer — one-liner for constitution skill.
# Usage: curl -fsSL https://raw.githubusercontent.com/phanijapps/constitution/main/remote-install.sh | bash
set -euo pipefail

REPO_URL="https://github.com/phanijapps/constitution"
TEMP_DIR="$(mktemp -d)"
SKILL_NAME="constitution"

cleanup() { rm -rf "$TEMP_DIR"; }
trap cleanup EXIT

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║   constitution — remote installer        ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""

# Clone minimal (skill/ directory only)
if command -v git >/dev/null 2>&1; then
  git clone --depth 1 --filter=blob:none --sparse "$REPO_URL" "$TEMP_DIR" 2>/dev/null
  (cd "$TEMP_DIR" && git sparse-checkout set skill) 2>/dev/null
else
  echo "  error: git is required" >&2; exit 1
fi

if [ ! -d "$TEMP_DIR/skill" ]; then
  echo "  error: failed to download skill" >&2; exit 1
fi

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
  cp -r "$TEMP_DIR/skill" "$dest/$SKILL_NAME"
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
