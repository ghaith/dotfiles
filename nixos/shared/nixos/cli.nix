{ pkgs, self, ... }: {
  programs.zsh.enable = true;

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  environment.systemPackages =
    (self.cliToolPackages pkgs)
    ++ (with pkgs; [
      # NixOS-only extras (not needed in devcontainers)
      tmux
      zellij
      rust-analyzer
      python3Packages.pynvim
      nh
    ]);
}
