# Global Claude Code Context

Use these files as the canonical context before making decisions:

- `~/.config/ai-context/preferences.md`
- `~/.config/ai-context/environment/chezmoi.md`
- `~/.config/ai-context/environment/nixos.md`
- `~/.config/ai-context/agents/*.md`

## Working style

- Be concise and direct
- Don't apologize or hedge
- When unsure, ask rather than guess

## Environment notes

- Dotfiles source: `~/.local/share/chezmoi/`
- NixOS config: `~/dotfiles/nixos/`
- Determine hostname with `hostname` before host-specific NixOS edits

## Reusable specialist roles

When asked to act as a specialist, use the matching role definition:

- Scout: `~/.config/ai-context/agents/scout.md`
- Planner: `~/.config/ai-context/agents/planner.md`
- Worker: `~/.config/ai-context/agents/worker.md`
- Reviewer: `~/.config/ai-context/agents/reviewer.md`
