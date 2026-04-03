# NixOS Configuration

## Security Rules

- **NEVER commit SSH keys** — private OR public. No `id_*`, `*.pub`, `authorized_keys`, or any key material.
- **NEVER commit secrets** — passwords, tokens, API keys. Use agenix/sops-nix for secrets management if needed.
- Hardware configs may contain UUIDs — these are fine, they're disk identifiers not secrets.

## Structure

This is a [flake-parts](https://flake.parts) NixOS config using [import-tree](https://github.com/vic/import-tree) for auto-module discovery.

```
nixos/
├── flake.nix          # Entry point — inputs + mkFlake via import-tree
├── modules/           # Auto-imported flake-parts modules
│   ├── parts.nix      # Systems list
│   └── nixos.nix      # Host → nixosConfiguration mappings
├── shared/            # Reusable configs, explicitly imported by hosts
│   ├── nixos/         # NixOS modules (cli.nix, desktop.nix)
│   └── home/          # Home-manager modules (future)
└── hosts/             # Per-machine configs
    └── nixos-vm/      # VM host (CLI-only, QEMU guest)
```

## Conventions

- **Modularity first** — split by concern, not by host. Shared modules go in `shared/`, host-specific in `hosts/`.
- **modules/** is for flake-parts modules only — they're auto-discovered by `import-tree`.
- **shared/** modules must be explicitly imported by hosts that need them.
- New hosts get their own directory under `hosts/` and are registered in `modules/nixos.nix`.
- `inputs` are passed to NixOS modules via `specialArgs`.
- Use `nixos-unstable` channel. Keep `flake.lock` updated.

## Build

```bash
sudo nixos-rebuild switch --flake ~/dotfiles/nixos#<hostname>
```
