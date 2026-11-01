#!/usr/bin/env bash
# constitution installer — works piped from curl OR run locally after clone.
#
# Remote (interactive):   curl -fsSL https://raw.githubusercontent.com/phanijapps/constitution/main/install.sh | bash
# Remote (non-interactive): curl -fsSL .../install.sh | bash -s -- --agent claude
# Local:                  git clone ... && cd constitution && ./install.sh
set -euo pipefail

REPO_URL="https://github.com/phanijapps/constitution"
SKILL_NAME="constitution"
AGENT_CHOICE=""

# Parse flags
while [ $# -gt 0 ]; do
  case "$1" in
    --agent) AGENT_CHOICE="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# Detect mode: piped (BASH_SOURCE unset/empty) vs local (script file exists)
SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"
fi
TEMP_DIR=""

if [ -n "$SCRIPT_DIR" ] && [ -d "$SCRIPT_DIR/skill" ]; then
  SKILL_DIR="$SCRIPT_DIR/skill"
  MODE="local"
else
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

# Map agent names to choice numbers
agent_to_choice() {
  case "$1" in
    claude|claude-code|1) echo 1 ;;
    codex|2) echo 2 ;;
    cursor|3) echo 3 ;;
    kiro|4) echo 4 ;;
    copilot|github-copilot|5) echo 5 ;;
    all|6) echo 6 ;;
    *) echo "" ;;
  esac
}

# Determine choice: from flag, or ask
if [ -z "$AGENT_CHOICE" ]; then
  echo ""
  echo "  ╔══════════════════════════════════════════╗"
  echo "  ║   constitution — installer ($MODE)        ║"
  echo "  ╚══════════════════════════════════════════╝"
  echo ""
  echo "  Select your coding agent (installed into: $PWD)"
  echo ""
  echo "  1) Claude Code     (.claude/skills/)"
  echo "  2) Codex           (.agents/skills/)"
  echo "  3) Cursor          (.cursor/skills/)"
  echo "  4) Kiro IDE/CLI     (.kiro/skills/)"
  echo "  5) GitHub Copilot  (.github/skills/)"
  echo "  6) All (Claude + Codex + Cursor + Kiro)"
  echo ""
  # Try /dev/tty first, then stdin, then fail cleanly
  if [ -t 0 ] 2>/dev/null; then
    read -rp "  Enter number [1-6]: " choice
  elif [ -r /dev/tty ] 2>/dev/null; then
    read -rp "  Enter number [1-6]: " choice < /dev/tty
  else
    echo "  error: no interactive terminal available." >&2
    echo "  Use: curl ... | bash -s -- --agent <claude|codex|cursor|kiro|copilot|all>" >&2
    exit 1
  fi
else
  choice="$(agent_to_choice "$AGENT_CHOICE")"
  if [ -z "$choice" ]; then
    echo "  error: unknown agent '$AGENT_CHOICE'" >&2
    echo "  valid: claude codex cursor kiro copilot all" >&2
    exit 1
  fi
fi

echo ""

install_to() {
  local dest="$1"
  mkdir -p "$dest"
  rm -rf "$dest/$SKILL_NAME"
  cp -r "$SKILL_DIR" "$dest/$SKILL_NAME"
  echo "  ✓ installed to $dest/$SKILL_NAME"
}

case "$choice" in
  1) install_to ".claude/skills" ;;
  2) install_to ".agents/skills" ;;
  3) install_to ".cursor/skills" ;;
  4) install_to ".kiro/skills" ;;
  5) install_to ".github/skills" ;;
  6)
    install_to ".claude/skills"
    install_to ".agents/skills"
    install_to ".cursor/skills"
    install_to ".kiro/skills"
    ;;
  *) echo "  invalid choice: $choice" >&2; exit 1 ;;
esac

echo ""
echo "  Done. Verify with:"
case "$choice" in
  1) echo "    python3 .claude/skills/$SKILL_NAME/scripts/scaffold.py --help" ;;
  2) echo "    python3 .agents/skills/$SKILL_NAME/scripts/scaffold.py --help" ;;
  3) echo "    python3 .cursor/skills/$SKILL_NAME/scripts/scaffold.py --help" ;;
  4) echo "    python3 .kiro/skills/$SKILL_NAME/scripts/scaffold.py --help" ;;
  5) echo "    python3 .github/skills/$SKILL_NAME/scripts/scaffold.py --help" ;;
  6) echo "    python3 .claude/skills/$SKILL_NAME/scripts/scaffold.py --help" ;;
esac
echo ""
