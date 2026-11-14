# Managed by chezmoi. Distribution defaults first, then the shared dotfiles
# setup (~/.config/fish/dotfiles.fish), so the dotfiles win where they overlap.
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

source ~/.config/fish/dotfiles.fish
