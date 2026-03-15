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
- fonts/themes helpers: Nerd Fonts, tmux catppuccin plugin, fuzzel theme clone

---

## Repository layout

- `install.sh` – Linux bootstrap (packages + fnm/node + pi + chezmoi init/apply)
- `install.ps1` – Windows bootstrap (winget/choco + fnm/node + pi + chezmoi init/apply)
- `.chezmoiscripts/run_once_before_00-bootstrap.sh` – runs bootstrap when initialized through chezmoi
- `run_after_install-pi-extensions.sh` – installs npm deps for pi extensions
- `run_after_install-tmux-catppuccin.sh` – installs tmux catppuccin plugin
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

> ⚠️ Note: the Windows bootstrap path exists, but is currently **not tested**.

Run PowerShell as Administrator:

```powershell
./install.ps1
```

It uses winget for most packages, Chocolatey for Nerd Fonts, then initializes chezmoi.

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

---

## Troubleshooting

- Check node availability:
  - `fnm current`
  - `node -v`
  - `npm -v`
- Re-open shell after first install (`exec zsh` or new terminal)
- If chezmoi source is wrong, pass explicit source:
  - `./install.sh --source https://github.com/ghaith/dotfiles.git`
