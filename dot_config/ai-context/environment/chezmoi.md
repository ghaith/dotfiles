# Dotfiles and Pi Config via Chezmoi

Pi config lives in `~/.pi/agent/`. Chezmoi manages the portable parts.

## Chezmoi Source Structure

```
~/.local/share/chezmoi/
├── .chezmoiignore
└── private_dot_pi/
    └── agent/
        ├── AGENTS.md
        ├── extensions/
        ├── prompts/
        ├── skills/
        └── themes/
```

## Managed by chezmoi (portable)

- `settings.json` — via `modify_` script, only stable preferences
- `themes/` — custom theme JSON files
- `extensions/` — custom extensions
- `skills/` — custom skills
- `prompts/` — reusable prompts
- `AGENTS.md` — global preferences and references

## Not managed by chezmoi (machine-local)

- `auth.json` — OAuth tokens and API keys
- `sessions/` — conversation history
- `usage.json` — usage/runtime state

## Notes

- This repository is the chezmoi source at `~/.local/share/chezmoi/`
- On this setup, home-manager runs `chezmoi apply` during `nixos-rebuild switch`
