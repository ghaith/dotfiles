# NixOS notes

## Rebuild this system

```bash
cd ~/dotfiles/nixos
sudo nixos-rebuild switch --flake .#$(hostname)
```

If you use `nh`, this is equivalent:

```bash
cd ~/dotfiles/nixos
nh os switch .
```

## Update NixOS packages / flake inputs

```bash
cd ~/dotfiles/nixos
nix flake update
sudo nixos-rebuild switch --flake .#$(hostname)
```

Useful review step before rebuilding:

```bash
git -C ~/dotfiles diff -- nixos/flake.lock
```

## Update portable nix profile packages on non-NixOS machines

This applies to tools installed with `nix profile install`, such as the `cli-tools`
bundle from this repo.

```bash
nix profile list
nix profile upgrade --all
```

## Cleanup

```bash
nix store gc
```

On NixOS you can also inspect generations:

```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

## Arch package updates

If you are using the imperative Arch bootstrap instead of Nix-managed packages:

```bash
sudo pacman -Syu
```
