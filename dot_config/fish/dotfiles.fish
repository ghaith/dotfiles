# Managed by chezmoi. Fish counterpart of ~/.local/bin/shell-common and
# ~/.local/bin/env (bash/zsh); keep the two in step.

# ── PATH ─────────────────────────────────────────────────────────────
for dir in /usr/local/go/bin ~/.local/usr/bin /snap/bin ~/.local/npm/bin ~/.cargo/bin ~/.local/share/fnm ~/.local/scripts ~/.local/bin
    test -d $dir; and fish_add_path --global --path --move $dir
end
test -e ~/.nix-profile/bin; and fish_add_path --global --path ~/.nix-profile/bin

# ── Environment ──────────────────────────────────────────────────────
set -gx XDG_CONFIG_HOME ~/.config
set -gx TREE_IGNORE 'cache|log|logs|node_modules|vendor'
if command -q nvim
    set -gx EDITOR nvim
else if command -q vim
    set -gx EDITOR vim
else
    set -gx EDITOR vi
end
set -gx VISUAL $EDITOR

# The user ssh-agent (ssh-agent.service), else whatever the session provides.
if set -q XDG_RUNTIME_DIR; and test -S $XDG_RUNTIME_DIR/ssh-agent.socket
    set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
end
set -e SSH_ASKPASS
set -e SSH_ASKPASS_REQUIRE

if command -q podman; and not command -q docker
    set -gx DOCKER_HOST unix://(set -q XDG_RUNTIME_DIR; and echo $XDG_RUNTIME_DIR; or echo /run/user/(id -u))/podman/podman.sock
end

status is-interactive; or exit

# ── Interactive ──────────────────────────────────────────────────────
set -gx GPG_TTY (tty)
set -g fish_key_bindings fish_vi_key_bindings

alias vim nvim
alias dark 'theme-switch mocha'
alias light 'theme-switch latte'
alias ls 'eza --group-directories-first'
alias la 'eza --group-directories-first -a'
alias ll 'eza --group-directories-first --git -l'
alias lt 'eza --group-directories-first --tree -D -L 2 -I $TREE_IGNORE'
alias ltt 'eza --group-directories-first --tree -D -L 3 -I $TREE_IGNORE'

command -q fnm; and fnm env --shell fish --use-on-cd | source
command -q zoxide; and zoxide init fish | source
command -q direnv; and direnv hook fish | source
command -q starship; and starship init fish | source
command -q atuin; and atuin init fish | source
test -x /usr/bin/micromamba; and /usr/bin/micromamba shell hook --shell fish | source

# Export KEY=VALUE lines from .env when entering a directory (like zsh's load-env).
function __dotfiles_load_env --on-variable PWD
    test -f .env; or return
    for line in (string match -rv '^\s*(#|$)' < .env)
        set -l kv (string split -m 1 = -- (string replace -r '^export\s+' '' -- $line))
        test (count $kv) -eq 2; or continue
        set -gx $kv[1] (string trim -c '"\'' -- $kv[2])
    end
end

function pdfcompress --description 'Shrink a PDF with Ghostscript'
    gs -q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dPDFSETTINGS=/screen \
        -dEmbedAllFonts=true -dSubsetFonts=true -dColorImageDownsampleType=/Bicubic -dColorImageResolution=144 \
        -dGrayImageDownsampleType=/Bicubic -dGrayImageResolution=144 -dMonoImageDownsampleType=/Bicubic \
        -dMonoImageResolution=144 -sOutputFile="$argv[1].compressed.pdf" $argv[1]
end
