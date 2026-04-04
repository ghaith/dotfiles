# Preferences

- Be concise and direct
- Don't apologize or hedge
- When unsure, ask rather than guess

## Dotfiles

Pi config is managed via chezmoi. Use `/skill:chezmoi` for details on the setup before making changes to `~/.pi/agent/`.

## NixOS

This is a NixOS system. Config lives in `~/dotfiles/nixos/`. Use `/skill:nixos` for details.

### Hosts

| Host | Description |
|---|---|
| `ghaith-xps` | Dell XPS laptop, desktop environment (imports `cli.nix` + `desktop.nix`) |
| `nixos-vm` | QEMU VM, CLI-only (imports `cli.nix`) |

Home-manager is integrated — `nixos-rebuild switch` also runs `chezmoi apply` via a home-manager activation.
