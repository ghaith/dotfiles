# Dotfiles via Chezmoi

## Chezmoi Source Structure

```
~/.local/share/chezmoi/
├── .chezmoiignore
├── .chezmoiscripts/
├── dot_agents/      shared assistant context (preferences, roles, skills)
├── dot_claude/      Claude Code adapter
├── dot_config/
├── private_dot_local/
└── nixos/           NixOS config, not deployed as dotfiles
```

## Managed by chezmoi (portable)

- `~/.agents/` — shared preferences, roles, environments, and skills
- `~/.claude/CLAUDE.md` — Claude Code global adapter
- shell, editor, terminal and theme configuration

## Not managed by chezmoi (machine-local)

- Authentication tokens and API keys
- Conversation history and runtime state
- `~/.ssh/config.local` and other per-machine overrides

## Notes

- This repository is the chezmoi source at `~/.local/share/chezmoi/`
- On this setup, home-manager runs `chezmoi apply` during `nixos-rebuild switch`
