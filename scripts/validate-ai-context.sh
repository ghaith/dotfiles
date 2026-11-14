#!/usr/bin/env bash
# shellcheck disable=SC2088 # These are literal adapter strings, not shell paths.
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
check_file_exists "$ROOT_DIR/dot_agents/preferences.md"
check_file_exists "$ROOT_DIR/dot_agents/environment/chezmoi.md"
check_file_exists "$ROOT_DIR/dot_agents/environment/nixos.md"

for agent in scout planner worker reviewer; do
  check_file_exists "$ROOT_DIR/dot_agents/agents/$agent.md"
done

for skill in chezmoi nixos grill-me rubber-duck teacher; do
  skill_file="$ROOT_DIR/dot_agents/skills/$skill/SKILL.md"
  check_file_exists "$skill_file"
  check_contains "$skill_file" "name: $skill"
  check_contains "$skill_file" "description:"
done

# Claude adapter must reference shared context
CLAUDE_ADAPTER="$ROOT_DIR/dot_claude/CLAUDE.md"
check_file_exists "$CLAUDE_ADAPTER"
check_contains "$CLAUDE_ADAPTER" "~/.agents/preferences.md"
check_contains "$CLAUDE_ADAPTER" "~/.agents/agents/*.md"

for skill in chezmoi nixos grill-me rubber-duck teacher; do
  check_contains "$CLAUDE_ADAPTER" "~/.agents/skills/$skill/SKILL.md"
done


echo "[OK] AI context adapters are consistent with shared context."
