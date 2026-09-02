# Shared Context Adapter (Pi)

Canonical context lives in `~/.agents/`.

Read these first:

- `~/.agents/preferences.md`
- `~/.agents/agents/*.md`
- `~/.agents/environment/local-infra.md`

Load skills only when the task matches. Do not read every skill up front:

- `~/.agents/skills/chezmoi/SKILL.md`
- `~/.agents/skills/nixos/SKILL.md`
- `~/.agents/skills/grill-me/SKILL.md`
- `~/.agents/skills/rubber-duck/SKILL.md`
- `~/.agents/skills/teacher/SKILL.md`

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
- Use `/skill:rubber-duck`, `/rubber-duck`, or `/duck` when the user wants to drive the programming and have you act as a sounding board. Stay in that mode until the user says to stop.
- Use `/skill:teacher`, `/teacher`, or phrases like “teacher mode” / “teach me” when the user wants guided learning through exercises, hints, editor steps, and checks instead of having you do the programming for them. Stay in that mode until the user says to stop.
