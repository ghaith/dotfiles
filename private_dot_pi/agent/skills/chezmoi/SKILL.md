---
name: chezmoi
description: Pi dotfiles management and chezmoi setup. Use when working on pi config, extensions, themes, or dotfiles.
---

# Pi Config via Chezmoi

Pi config lives in `~/.pi/agent/`. Chezmoi manages the portable parts.

## Chezmoi Source Structure

```
~/.local/share/chezmoi/
├── .chezmoiignore
├── run_after_install-pi-extensions.sh
└── private_dot_pi/
    └── agent/
        ├── AGENTS.md
        ├── modify_settings.json
        ├── themes/
        │   └── catppuccin-mocha.json
        └── extensions/
            └── plan-mode/
                ├── index.ts
                └── utils.ts
```

## What's Managed

### By chezmoi (portable)
- `settings.json` — via `modify_` script, only stable preferences (e.g., `theme`). Pi-managed keys like `defaultModel`, `defaultProvider`, `lastChangelogVersion` are left untouched.
- `themes/` — custom theme JSON files
- `extensions/` — custom extensions (TypeScript files)
- `skills/` — custom skills like this one
- `AGENTS.md` — global preferences

### NOT by chezmoi (machine-local)
- `auth.json` — OAuth tokens and API keys, created per-machine via `/login` or env vars
- `sessions/` — conversation history

## Adding New Extensions

1. Create and test in `~/.pi/agent/extensions/`
2. Run `chezmoi add ~/.pi/agent/extensions/<name>`
3. If the extension has npm deps, add `package.json` and `package-lock.json` (not `node_modules/`)
4. `run_after_install-pi-extensions.sh` handles `npm install` on `chezmoi apply`

## Adding New Themes

1. Create in `~/.pi/agent/themes/`
2. Run `chezmoi add ~/.pi/agent/themes/<name>.json`
3. Update `modify_settings.json` in chezmoi source if you want it as the default theme

## Adding New Skills or Prompts

Same pattern — create in `~/.pi/agent/skills/` or `~/.pi/agent/prompts/`, then `chezmoi add`.

## Settings Merge

`modify_settings.json` is a shell script that merges chezmoi-owned keys via `jq`. Pi's runtime keys (model, provider, etc.) are preserved. To add a new managed key, edit the `jq` expression in:

```
~/.local/share/chezmoi/private_dot_pi/agent/modify_settings.json
```

## Testing install.sh Changes

When modifying `install.sh` (e.g. adding packages), test the relevant package-install commands in Docker on all supported distros. You don't need to run the full script — just verify the package names resolve:

```bash
# Arch
docker run --rm archlinux:latest bash -c "pacman -Sy --noconfirm && pacman -S --noconfirm <packages>"

# Ubuntu (latest LTS)
docker run --rm ubuntu:latest bash -c "apt-get update && apt-get install -y <packages>"

# Debian (stable)
docker run --rm debian:stable bash -c "apt-get update && apt-get install -y <packages>"

# Fedora
docker run --rm fedora:latest bash -c "dnf install -y <packages>"
```

Always test before committing — package names differ across distros (e.g. `fd-find` vs `fd`, `bat` vs `batcat`).
