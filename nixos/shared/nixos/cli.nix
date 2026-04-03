{ pkgs, self, ... }: {
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    # shell
    zsh
    starship
    zoxide
    atuin
    fzf

    # editor
    self.packages.${pkgs.stdenv.hostPlatform.system}.neovim
    helix

    # file tools
    bat
    eza
    fd
    ripgrep
    delta
    jq

    # multiplexer
    tmux
    zellij

    # dev
    git
    gh
    go
    fnm
    rustup
    rust-analyzer
    uv
    python3Packages.pynvim

    # ai agents
    pi-coding-agent
    self.packages.${pkgs.stdenv.hostPlatform.system}.claude-code

    # system
    chezmoi
    curl
    htop
  ];
}
