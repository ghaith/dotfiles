# Dotfiles and Pi Config via Chezmoi

Pi config lives in `~/.pi/agent/`. Chezmoi manages the portable parts.

## Chezmoi Source Structure

```
~/.local/share/chezmoi/
├── .chezmoiignore
├── dot_agents/
├── dot_codex/
└── private_dot_pi/
    └── agent/
        ├── AGENTS.md
        ├── extensions/
        ├── prompts/
        ├── skills/
        └── themes/
```

## Managed by chezmoi (portable)

- `~/.agents/` — shared preferences, roles, environments, and skills
- `~/.codex/AGENTS.md` — Codex global adapter
- `~/.pi/agent/AGENTS.md` — Pi global adapter
- `~/.pi/agent/settings.json` — via `modify_` script, only stable preferences
- `~/.pi/agent/themes/` — custom theme JSON files
- `~/.pi/agent/extensions/` — custom extensions
- `~/.pi/agent/skills/` — Pi skill adapters
- `~/.pi/agent/prompts/` — reusable prompts

## Not managed by chezmoi (machine-local)

- Authentication tokens and API keys
- Conversation history and runtime state
- `~/.codex/config.toml` — machine-specific model and project trust settings

## Notes

- This repository is the chezmoi source at `~/.local/share/chezmoi/`
- On this setup, home-manager runs `chezmoi apply` during `nixos-rebuild switch`
