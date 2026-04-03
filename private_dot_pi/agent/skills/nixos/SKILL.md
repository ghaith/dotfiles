---
name: nixos
description: NixOS system configuration with flake-parts. Use when working on NixOS modules, packages, hosts, or flake config.
---

# NixOS Configuration

NixOS config lives in `~/dotfiles/nixos/`, separate from chezmoi (chezmoi ignores it via `.chezmoiignore`).

## Architecture

Built on [flake-parts](https://flake.parts) with [import-tree](https://github.com/vic/import-tree) for auto-discovery of modules, and [nix-wrapper-modules](https://birdeehub.github.io/nix-wrapper-modules/) for wrapped programs.

### Flake entry point

`flake.nix` declares inputs and delegates to `flake-parts.lib.mkFlake`, importing both `modules/` and `programs/` via `import-tree`.

### Inputs

| Input | Purpose |
|---|---|
| `nixpkgs` | nixos-unstable channel |
| `flake-parts` | Modular flake structure |
| `import-tree` | Auto-import all `.nix` files in a directory tree |
| `claude-code-nix` | Claude Code package |
| `wrapper-modules` | Nix wrapper modules for wrapped programs |

## Directory Structure

```
nixos/
├── flake.nix                      # Flake entry — inputs + mkFlake
├── flake.lock
├── modules/                       # Auto-imported flake-parts modules
│   ├── parts.nix                  # flake-parts config (systems, wrapper-modules import)
│   └── nixos.nix                  # Defines flake.nixosConfigurations per host
├── programs/                      # Auto-imported wrapped program definitions
│   └── neovim.nix                 # Wrapped neovim with LSPs and treesitter
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

- **`parts.nix`** — sets `systems`, imports `wrapper-modules.flakeModules.wrappers`
- **`nixos.nix`** — defines `flake.nixosConfigurations` mapping host names to their configs. Passes `inputs` and `self` via `specialArgs`.

### Programs (`programs/`)

Also consumed by `import-tree`. Each file defines a wrapped program using [nix-wrapper-modules](https://birdeehub.github.io/nix-wrapper-modules/). Programs are:

- **OS-agnostic** — exposed as `packages.<system>.<name>` flake outputs
- **Self-contained** — bundle their runtime deps (LSPs, formatters, etc.) on PATH
- **Reusable** — the wrapper definition lives on `flake.<name>Wrapper`, consumable by both NixOS (`environment.systemPackages`) and home-manager

#### Pattern

Each program file exports two things:

1. **`flake.<name>Wrapper`** — the wrapper module definition (config, deps, specs)
2. **`perSystem.packages.<name>`** — the built package using `wrapper-modules.wrappers.<type>.wrap`

```nix
# programs/example.nix
{ inputs, lib, self, ... }: {
  flake.exampleWrapper = { config, wlib, pkgs, ... }: {
    imports = [ wlib.wrapperModules.<type> ];
    # ... wrapper config
  };

  perSystem = { pkgs, ... }: {
    packages.example = inputs.wrapper-modules.wrappers.<type>.wrap {
      inherit pkgs;
      imports = [ self.exampleWrapper ];
    };
  };
}
```

Hosts consume wrapped packages via `self.packages.${pkgs.stdenv.hostPlatform.system}.<name>`.

#### Current wrapped programs

- **neovim** — wraps neovim with LSPs (lua-language-server, nil, nixd, gopls, pyright, clang-tools, bash-language-server, marksman), formatters (stylua, alejandra, shellcheck, markdownlint-cli), and treesitter grammars. Lua config stays in `~/.config/nvim` (chezmoi-managed) via impure `stdpath('config')`.

### Shared (`shared/`)

Reusable NixOS modules, importable by any host. Not auto-imported — hosts explicitly `import` what they need.

- **`shared/nixos/cli.nix`** — CLI tools (zsh, wrapped neovim, git, rustup, pi, claude-code, etc.)
- **`shared/nixos/desktop.nix`** — Desktop/GUI packages (wl-clipboard, fuzzel, nerd fonts)
- **`shared/home/`** — Reserved for future home-manager modules

### Hosts (`hosts/`)

Per-machine configs. Each host is a directory with a `default.nix` that imports shared modules and sets machine-specific options (bootloader, hostname, users, locale).

Currently: `nixos-vm` (QEMU guest, CLI-only — imports `cli.nix` but not `desktop.nix`).

## Common Tasks

### Adding a wrapped program

1. Create `programs/<name>.nix` following the wrapper pattern above
2. `import-tree` picks it up automatically
3. Reference from shared/host modules as `self.packages.${pkgs.stdenv.hostPlatform.system}.<name>`
4. Wrapper module docs: https://birdeehub.github.io/nix-wrapper-modules/

### Adding a package (unwrapped)

1. Decide scope: all machines → `shared/nixos/cli.nix`, desktop → `shared/nixos/desktop.nix`, one host → host's `default.nix`
2. Add to `environment.systemPackages`
3. Rebuild: `sudo nixos-rebuild switch --flake ~/dotfiles/nixos#<hostname>`

### Adding a new host

1. Create `hosts/<hostname>/default.nix` with host-specific config
2. Run `nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix` on the target machine
3. Import desired shared modules (e.g., `../../shared/nixos/cli.nix`, `../../shared/nixos/desktop.nix`)
4. Register in `modules/nixos.nix`:
   ```nix
   <hostname> = inputs.nixpkgs.lib.nixosSystem {
     specialArgs = { inherit inputs self; };
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

## Migration Plan

Config files are currently managed by chezmoi in `~/dotfiles/dot_config/`. As programs get wrapped:

1. **Phase 1 (current)**: Wrap programs with nix for deps (LSPs, tools). Config stays in chezmoi.
2. **Phase 2**: Add home-manager. Migrate config into nix where it makes sense (programs with `programs.<name>.enable`).
3. **Phase 3**: For non-NixOS (devcontainers), home-manager standalone provides the same wrapped programs.

## References

- [flake-parts docs](https://flake.parts)
- [nix-wrapper-modules docs](https://birdeehub.github.io/nix-wrapper-modules/)
- [NixOS manual](https://nixos.org/manual/nixos/unstable/)
