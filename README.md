# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/), with bootstrap scripts for Linux and Windows.

## TL;DR

```bash
# 1) Install/apply dotfiles directly
chezmoi init --apply ghaith/dotfiles

# or bootstrap from curl
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ghaith/dotfiles/main/install.sh)"

# 2) Open a new shell and verify node/pi
node -v && pi --help
```

This repo installs and configures:

- shell: `zsh`, shared shell config for `bash` + `zsh`
- editor/tools: `neovim`, `helix`, `ripgrep`, `fd`, `fzf`, `bat`, `eza`, `zoxide`, `starship`, `atuin`, `git-delta`
- language/runtime: `go`, `rust`, `fnm` + Node LTS
- pi agent: `@mariozechner/pi-coding-agent`
- fonts/themes helpers: Nerd Fonts, tmux catppuccin plugin

---

## Repository layout

- `install.sh` – Linux bootstrap (packages + fnm/node + pi + chezmoi init/apply)
- `.chezmoiscripts/run_once_before_00-bootstrap.sh` – runs bootstrap when initialized through chezmoi
- `run_after_install-pi-extensions.sh` – installs npm deps for pi extensions
- `run_after_install-tmux-catppuccin.sh` – installs tmux catppuccin plugin
- `create_private_dot_gitconfig.local.tmpl` – seeds `~/.gitconfig.local` once, then never touches it
- `dot_*`, `private_dot_*`, `dot_config/` – managed dotfiles/templates

---

## Quick start (Linux)

### Option A (recommended): initialize directly with chezmoi

```bash
chezmoi init --apply ghaith/dotfiles
```

What happens:

1. chezmoi clones/applies dotfiles
2. `.chezmoiscripts/run_once_before_00-bootstrap.sh` calls `install.sh --from-chezmoi`
3. packages and runtimes are installed
4. shell/npm/fnm/pi setup is configured

### Option B: bootstrap via curl

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ghaith/dotfiles/main/install.sh)"
```

If the local dotfiles source directory does not exist, `install.sh` automatically falls back to:

- `https://github.com/ghaith/dotfiles.git`

and runs `chezmoi init --apply` against that repo.

---

## `install.sh` options

```text
--from-chezmoi        Run bootstrap tasks without calling `chezmoi init`
--skip-chezmoi-init   Alias for --from-chezmoi
--source <path|repo>  Override chezmoi source (local path or remote repo URL)
```

Also supported via env var:

- `CHEZMOI_SOURCE=<path|repo>`

Examples:

```bash
./install.sh --source ~/src/dotfiles
./install.sh --source https://github.com/ghaith/dotfiles.git
CHEZMOI_SOURCE=~/src/dotfiles ./install.sh
```

---

## Node/fnm behavior

`fnm` is initialized in shared shell config with:

- `fnm env --shell zsh --use-on-cd` (zsh)
- `fnm env --shell bash --use-on-cd` (bash)

Bootstrap installs Node LTS and sets it as default:

```bash
fnm install --lts
fnm default lts-latest
```

This ensures `node`/`npm` are available for `pi` after install.

---

## Windows

Windows is a **config-only** target — nothing is installed and no shell
config is deployed. `.chezmoiignore` narrows it to an allowlist:

| Target | Notes |
| --- | --- |
| `.config/nvim` | needs `XDG_CONFIG_HOME`, see below |
| `.config/wezterm` | terminal of choice on Windows |
| `.config/starship` | needs `STARSHIP_CONFIG` pointing at it |
| `.gitconfig` | |

### Environment variables

Windows needs two user-scope variables (no admin required; restart the shell after
setting them):

```powershell
[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", "$env:USERPROFILE\.config", "User")
[Environment]::SetEnvironmentVariable("GIT_CONFIG_GLOBAL", "$env:USERPROFILE\.gitconfig", "User")
```

- `XDG_CONFIG_HOME` — Neovim on Windows reads `%LOCALAPPDATA%\nvim` unless this is
  set. Also fixes starship, bat, and anything else XDG-aware.
- `GIT_CONFIG_GLOBAL` — on a domain-joined machine `HOMEDRIVE` is a network share,
  so git resolves `~` to it and ignores the config chezmoi writes under
  `%USERPROFILE%`. This repoints git's global config without moving `HOME`
  (which would orphan SSH keys and anything else on the share). The corporate
  config is pulled back in as a low-precedence `[include]`, so local settings win
  and git keeps working when the share is offline.

> `destDir` is pinned to `%USERPROFILE%` in `.chezmoi.toml.tmpl`. Without it,
> running chezmoi from Git Bash targets the network share (Git Bash derives `HOME`
> from `HOMEDRIVE`) while PowerShell targets `C:\Users\<user>` — two different
> destinations sharing one state database.

Install the tools you want by hand — user-local installs are fine and no
package manager is assumed — then:

```powershell
chezmoi init --apply
```

`.chezmoiscripts/` is skipped entirely on Windows. The scripts are POSIX
shell, and Windows has no shebang support, so chezmoi's `fork/exec` of the
extracted `.sh` fails with `%1 is not a valid Win32 application` and aborts
the whole apply.

---

## Updating dotfiles

From an existing machine:

```bash
chezmoi update
chezmoi apply
```

Preview changes first:

```bash
chezmoi diff
```

## Tooling updates

### Arch / CachyOS packages

```bash
sudo pacman -Syu
```

### NixOS system packages

```bash
cd ~/dotfiles/nixos
nix flake update
sudo nixos-rebuild switch --flake .#$(hostname)
```

### Portable nix profile packages

```bash
nix profile upgrade --all
```

More NixOS notes live in `nixos/README.md`.

---

## Writing / spell / grammar tools

Default install now includes:

- `shellcheck` — shell linting
- `typos` + `typos-lsp` — typo checking for code and prose
- `harper` — lightweight English grammar/style checks
- `vim-spell-en` — Neovim English spell files

Optional Arch packages for extra Neovim spell languages:

```bash
sudo pacman -S vim-spell-de vim-spell-fr vim-spell-nl vim-spell-es
```

## Troubleshooting

- Check node availability:
  - `fnm current`
  - `node -v`
  - `npm -v`
- Re-open shell after first install (`exec zsh` or new terminal)
- If chezmoi source is wrong, pass explicit source:
  - `./install.sh --source https://github.com/ghaith/dotfiles.git`
