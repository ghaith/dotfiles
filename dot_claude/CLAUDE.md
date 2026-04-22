# Global Claude Code Context

Use these files as the canonical always-on context before making decisions:

- `~/.config/ai-context/preferences.md`
- `~/.config/ai-context/agents/*.md`

Load skills only when the task matches. Do not read every skill up front:

- `~/.config/ai-context/skills/chezmoi.md`
- `~/.config/ai-context/skills/nixos.md`
- `~/.config/ai-context/skills/grill-me.md`

## Working style

- Be concise and direct
- Don't apologize or hedge
- When unsure, ask rather than guess

## Environment notes

- Dotfiles source: `~/.local/share/chezmoi/`
- NixOS config: `~/dotfiles/nixos/`

## Reusable specialist roles

When asked to act as a specialist, use the matching role definition:

- Scout: `~/.config/ai-context/agents/scout.md`
- Planner: `~/.config/ai-context/agents/planner.md`
- Worker: `~/.config/ai-context/agents/worker.md`
- Reviewer: `~/.config/ai-context/agents/reviewer.md`

## Reusable playbooks

- Chezmoi: `~/.config/ai-context/skills/chezmoi.md` — load only for dotfiles, Pi config, extensions, themes, or other chezmoi-managed files.
- NixOS: `~/.config/ai-context/skills/nixos.md` — load only for NixOS modules, packages, hosts, or flake config.
- Grill Me: `~/.config/ai-context/skills/grill-me.md` — load only when the user wants a plan or design stress-tested through one-question-at-a-time questioning.

## Plan to implementation transition

When you have produced a plan and are about to move into implementation, keep your normal question or confirmation flow.

Additionally, ask whether the user wants to discuss the plan in detail before implementation.

If the user wants detailed discussion, load and follow:

- `~/.config/ai-context/skills/grill-me.md`

Stay in discussion mode and do not start implementing until the user explicitly asks to proceed.
