# NixOS

Use when working on NixOS modules, packages, hosts, or flake config.

Do not load this skill unless the task actually involves NixOS config.

## Source of truth

Read and follow:

- `~/.config/ai-context/environment/nixos.md`

## Required workflow

When making host-specific edits, always:

1. Run `hostname`
2. Find the matching host under `~/dotfiles/nixos/hosts/`
3. Prefer shared modules when possible
