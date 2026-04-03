---
name: nixos
description: NixOS system configuration with flake-parts. Use when working on NixOS modules, packages, hosts, or flake config.
---

# NixOS Configuration

NixOS config lives in `~/dotfiles/nixos/`, separate from chezmoi (chezmoi ignores it via `.chezmoiignore`).

## Architecture

Built on [flake-parts](https://flake.parts) with [import-tree](https://github.com/vic/import-tree) for auto-discovery of modules.

### Flake entry point

`flake.nix` declares inputs and delegates to `flake-parts.lib.mkFlake`, importing everything under `modules/` via `import-tree`.

### Inputs

| Input | Purpose |
|---|---|
| `nixpkgs` | nixos-unstable channel |
| `flake-parts` | Modular flake structure |
| `import-tree` | Auto-import all `.nix` files in a directory tree |
| `claude-code-nix` | Claude Code package |

## Directory Structure

```
nixos/
├── flake.nix                      # Flake entry — inputs + mkFlake
├── flake.lock
├── modules/
│   ├── parts.nix                  # flake-parts config (systems list)
│   └── nixos.nix                  # Defines flake.nixosConfigurations per host
├── shared/
│   ├── nixos/
│   │   ├── cli.nix                # CLI packages (editors, dev tools, agents)
│   │   └── desktop.nix            # Desktop packages (wayland, fonts, launcher)
│   └── home/
│       └── .keep                  # Reserved for future home-manager modules
└── hosts/
    └── nixos-vm/
        ├── default.nix            # Host config (boot, networking, users, locale)
        └── hardware-configuration.nix  # Auto-generated hardware config
```

## Key Concepts

### Modules (`modules/`)

Consumed by `import-tree` — every `.nix` file here is auto-imported as a flake-parts module. No manual imports needed.

- **`parts.nix`** — sets `systems = [ "x86_64-linux" ]`
- **`nixos.nix`** — defines `flake.nixosConfigurations` mapping host names to their configs

### Shared (`shared/`)

OS-agnostic package sets and config, importable by any host. Not auto-imported — hosts explicitly `import` what they need.

- **`shared/nixos/cli.nix`** — CLI tools (zsh, neovim, git, rustup, pi, claude-code, etc.)
- **`shared/nixos/desktop.nix`** — Desktop/GUI packages (wl-clipboard, fuzzel, nerd fonts)
- **`shared/home/`** — Reserved for future home-manager modules

### Hosts (`hosts/`)

Per-machine configs. Each host is a directory with a `default.nix` that imports shared modules and sets machine-specific options (bootloader, hostname, users, locale).

Currently: `nixos-vm` (QEMU guest, CLI-only — imports `cli.nix` but not `desktop.nix`).

## Common Tasks

### Adding a package

1. Decide scope: all machines → `shared/nixos/cli.nix`, desktop machines → `shared/nixos/desktop.nix`, one host → that host's `default.nix`
2. Add to `environment.systemPackages`
3. Rebuild: `sudo nixos-rebuild switch --flake ~/dotfiles/nixos#<hostname>`

### Adding a new host

1. Create `hosts/<hostname>/default.nix` with host-specific config
2. Run `nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix` on the target machine
3. Import desired shared modules (e.g., `../../shared/nixos/cli.nix`, `../../shared/nixos/desktop.nix`)
4. Register in `modules/nixos.nix`:
   ```nix
   <hostname> = inputs.nixpkgs.lib.nixosSystem {
     specialArgs = { inherit inputs; };
     modules = [ ../hosts/<hostname> ];
   };
   ```
5. Build: `sudo nixos-rebuild switch --flake ~/dotfiles/nixos#<hostname>`

### Adding a new flake-parts module

Create a `.nix` file in `modules/`. `import-tree` picks it up automatically — no manual registration needed.

### Adding a new shared module

Create under `shared/nixos/` (or `shared/home/` for home-manager). Hosts must explicitly import it.

### Adding a flake input

1. Add to `inputs` in `flake.nix`
2. Use via `inputs.<name>` in modules (available through `specialArgs`)
3. Run `nix flake update` or `nix flake lock --update-input <name>`

## Rebuilding

```bash
# On the target machine
sudo nixos-rebuild switch --flake ~/dotfiles/nixos#<hostname>

# Remote build (future)
nixos-rebuild switch --flake ~/dotfiles/nixos#<hostname> --target-host <host> --use-remote-sudo
```

## References

- [flake-parts docs](https://flake.parts)
- [nix-wrapper-modules intro](https://birdeehub.github.io/nix-wrapper-modules/md/intro.html)
- [NixOS manual](https://nixos.org/manual/nixos/unstable/)
