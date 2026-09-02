# Global Antigravity Code Context

Use these files as the canonical always-on context before making decisions:

- `~/.agents/preferences.md`
- `~/.agents/agents/*.md`

Load skills only when the task matches. Do not read every skill up front:

- `~/.agents/skills/chezmoi/SKILL.md`
- `~/.agents/skills/nixos/SKILL.md`
- `~/.agents/skills/grill-me/SKILL.md`
- `~/.agents/skills/rubber-duck/SKILL.md`
- `~/.agents/skills/teacher/SKILL.md`

## Working style

- Be concise and direct
- Don't apologize or hedge
- When unsure, ask rather than guess

## Environment notes

- Dotfiles source: `~/.local/share/chezmoi/`
- NixOS config: `~/dotfiles/nixos/`

## Reusable specialist roles

When asked to act as a specialist, use the matching role definition:

- Scout: `~/.agents/agents/scout.md`
- Planner: `~/.agents/agents/planner.md`
- Worker: `~/.agents/agents/worker.md`
- Reviewer: `~/.agents/agents/reviewer.md`

## Reusable playbooks

- Chezmoi: `~/.agents/skills/chezmoi/SKILL.md` — load only for dotfiles, Pi config, extensions, themes, or other chezmoi-managed files.
- NixOS: `~/.agents/skills/nixos/SKILL.md` — load only for NixOS modules, packages, hosts, or flake config.
- Grill Me: `~/.agents/skills/grill-me/SKILL.md` — load only when the user wants a plan or design stress-tested through one-question-at-a-time questioning.
- Rubber Duck: `~/.agents/skills/rubber-duck/SKILL.md` — load when the user invokes `/rubber-duck` or `/duck`, or says "rubber duck mode"; the user drives the programming and you respond to what's asked instead of eagerly doing the whole task.
- Teacher: `~/.agents/skills/teacher/SKILL.md` — load when the user invokes `/teacher` or says "teacher mode" / "teach me"; guide them to learn through exercises, hints, editor steps, and checks instead of doing the programming for them.

## Plan to implementation transition

When you have produced a plan and are about to move into implementation, keep your normal question or confirmation flow.

Additionally, ask whether the user wants to discuss the plan in detail before implementation.

If the user wants detailed discussion, load and follow:

- `~/.agents/skills/grill-me/SKILL.md`

Stay in discussion mode and do not start implementing until the user explicitly asks to proceed.
