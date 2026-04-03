{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    # shell
    zsh
    starship
    zoxide
    atuin
    fzf

    # editor
    neovim
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
    uv
    python3Packages.pynvim

    # ai agents
    pi-coding-agent
    inputs.claude-code-nix.packages.${pkgs.system}.claude-code

    # system
    chezmoi
    curl
    htop
  ];
}
