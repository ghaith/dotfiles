{ self, ... }: {
  # Portable CLI tools bundle — installable on any Linux via `nix profile install`.
  # Used by install.sh on Ubuntu/Debian (and any non-NixOS system) to replace
  # distro-specific package installation.
  #
  # On NixOS, the same tools are installed via shared/nixos/cli.nix which
  # imports cliToolPackages from this module.

  # Shared package list used by both the portable bundle and NixOS cli.nix.
  flake.cliToolPackages = pkgs: with pkgs; [
    # shell
    zsh
    starship
    zoxide
    atuin
    fzf

    # editor
    self.packages.${pkgs.stdenv.hostPlatform.system}.neovim
    helix

    # file / git tools
    bat
    eza
    fd
    ripgrep
    delta
    jq
    git
    gh
    curl
    htop

    # dev
    direnv
    nix-direnv
    chezmoi

    # language runtimes
    go
    fnm
    rustup
    uv

    # build tools (needed for cargo builds)
    gcc

    # ai tools
    pi-coding-agent
    self.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
  ];

  perSystem = { pkgs, ... }: {
    packages.cli-tools = pkgs.symlinkJoin {
      name = "cli-tools";
      paths = self.cliToolPackages pkgs;
    };
  };
}
