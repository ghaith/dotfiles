# Shared Context Adapter (Pi)

Canonical context lives in `~/.config/ai-context/`.

Read these first:

- `~/.config/ai-context/preferences.md`
- `~/.config/ai-context/agents/*.md`

Load skills only when the task matches. Do not read every skill up front:

- `~/.config/ai-context/skills/chezmoi.md`
- `~/.config/ai-context/skills/nixos.md`
- `~/.config/ai-context/skills/grill-me.md`

## Preferences

- Be concise and direct
- Don't apologize or hedge
- When unsure, ask rather than guess

## Dotfiles

Pi config is managed via chezmoi. Only load `/skill:chezmoi` when changing dotfiles, Pi config, extensions, themes, or other chezmoi-managed files.

## NixOS

Config lives in `~/dotfiles/nixos/`. Only load `/skill:nixos` when the task actually involves NixOS config.

## Additional skills

- Use `/skill:grill-me` when the user wants a plan or design stress-tested through one-question-at-a-time interrogation.
