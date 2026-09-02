# Shared Context Adapter (Codex)

Canonical context lives in `~/.agents/`.

Read and follow this always-on context before making decisions:

- `~/.agents/preferences.md`

Load role definitions only when asked to act as that specialist:

- Scout: `~/.agents/agents/scout.md`
- Planner: `~/.agents/agents/planner.md`
- Worker: `~/.agents/agents/worker.md`
- Reviewer: `~/.agents/agents/reviewer.md`

Skills under `~/.agents/skills/` are canonical and shared across coding agents.
Load a skill only when the task matches its description, then follow any
environment reference named there.

## Environment notes

- Dotfiles source: `~/.local/share/chezmoi/`
- NixOS config: `~/dotfiles/nixos/`
