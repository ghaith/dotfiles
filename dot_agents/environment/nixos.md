# NixOS Environment

NixOS config lives in `~/dotfiles/nixos/` (separate from chezmoi deployment targets).

## Hosts

| Host | Description |
|---|---|
| `ghaith-xps` | Dell XPS laptop, desktop environment (imports `cli.nix` + `desktop.nix`) |
| `nixos-vm` | QEMU VM, CLI-only (imports `cli.nix`) |

## Architecture

- Flake-based config (`flake.nix`)
- `flake-parts` for modular structure
- `import-tree` for auto-discovery of `modules/` and `programs/`
- `home-manager` integrated into NixOS

## Important Paths

- `~/dotfiles/nixos/flake.nix`
- `~/dotfiles/nixos/modules/`
- `~/dotfiles/nixos/programs/`
- `~/dotfiles/nixos/shared/nixos/`
- `~/dotfiles/nixos/shared/home/`
- `~/dotfiles/nixos/hosts/<hostname>/`

## Rules for Changes

1. Determine current host first with `hostname`
2. Locate matching config under `hosts/`
3. Put shared changes in `shared/nixos/*.nix` when possible
4. Use host-specific changes only when machine-local

## Rebuild

```bash
sudo nixos-rebuild switch --flake ~/dotfiles/nixos#<hostname>
```

Home-manager is integrated, so rebuild also runs chezmoi apply via activation.
