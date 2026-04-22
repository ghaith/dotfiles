#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "[FAIL] $1" >&2
  exit 1
}

check_file_exists() {
  local file="$1"
  [[ -f "$file" ]] || fail "Missing file: $file"
}

check_contains() {
  local file="$1"
  local needle="$2"
  grep -Fq "$needle" "$file" || fail "$file is missing required text: $needle"
}

# Canonical shared context files
check_file_exists "$ROOT_DIR/dot_config/ai-context/preferences.md"
check_file_exists "$ROOT_DIR/dot_config/ai-context/environment/chezmoi.md"
check_file_exists "$ROOT_DIR/dot_config/ai-context/environment/nixos.md"
check_file_exists "$ROOT_DIR/dot_config/ai-context/agents/scout.md"
check_file_exists "$ROOT_DIR/dot_config/ai-context/agents/planner.md"
check_file_exists "$ROOT_DIR/dot_config/ai-context/agents/worker.md"
check_file_exists "$ROOT_DIR/dot_config/ai-context/agents/reviewer.md"
check_file_exists "$ROOT_DIR/dot_config/ai-context/skills/chezmoi.md"
check_file_exists "$ROOT_DIR/dot_config/ai-context/skills/nixos.md"
check_file_exists "$ROOT_DIR/dot_config/ai-context/skills/grill-me.md"

# Pi adapters must reference shared context
PI_AGENTS="$ROOT_DIR/private_dot_pi/agent/AGENTS.md"
check_file_exists "$PI_AGENTS"
check_contains "$PI_AGENTS" "~/.config/ai-context/preferences.md"
check_contains "$PI_AGENTS" "~/.config/ai-context/agents/*.md"
check_contains "$PI_AGENTS" "~/.config/ai-context/skills/chezmoi.md"
check_contains "$PI_AGENTS" "~/.config/ai-context/skills/nixos.md"
check_contains "$PI_AGENTS" "~/.config/ai-context/skills/grill-me.md"

check_contains "$ROOT_DIR/private_dot_pi/agent/skills/chezmoi/SKILL.md" "~/.config/ai-context/skills/chezmoi.md"
check_contains "$ROOT_DIR/private_dot_pi/agent/skills/nixos/SKILL.md" "~/.config/ai-context/skills/nixos.md"
check_contains "$ROOT_DIR/private_dot_pi/agent/skills/grill-me/SKILL.md" "~/.config/ai-context/skills/grill-me.md"

check_contains "$ROOT_DIR/private_dot_pi/agent/agents/scout.md" "~/.config/ai-context/agents/scout.md"
check_contains "$ROOT_DIR/private_dot_pi/agent/agents/planner.md" "~/.config/ai-context/agents/planner.md"
check_contains "$ROOT_DIR/private_dot_pi/agent/agents/worker.md" "~/.config/ai-context/agents/worker.md"
check_contains "$ROOT_DIR/private_dot_pi/agent/agents/reviewer.md" "~/.config/ai-context/agents/reviewer.md"

# Claude adapter must reference shared context
CLAUDE_ADAPTER="$ROOT_DIR/dot_claude/CLAUDE.md"
check_file_exists "$CLAUDE_ADAPTER"
check_contains "$CLAUDE_ADAPTER" "~/.config/ai-context/preferences.md"
check_contains "$CLAUDE_ADAPTER" "~/.config/ai-context/agents/*.md"
check_contains "$CLAUDE_ADAPTER" "~/.config/ai-context/skills/chezmoi.md"
check_contains "$CLAUDE_ADAPTER" "~/.config/ai-context/skills/nixos.md"
check_contains "$CLAUDE_ADAPTER" "~/.config/ai-context/skills/grill-me.md"

echo "[OK] AI context adapters are consistent with shared context."
