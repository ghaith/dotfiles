---
name: nixos
description: NixOS system configuration with flake-parts. Use when working on NixOS modules, packages, hosts, or flake config.
---

# NixOS Skill (Pi Adapter)

Canonical documentation lives in:

- `~/.config/ai-context/environment/nixos.md`

Read that file first.

When making host-specific edits, always:

1. Run `hostname`
2. Find matching host under `~/dotfiles/nixos/hosts/`
3. Apply changes in shared modules when possible
