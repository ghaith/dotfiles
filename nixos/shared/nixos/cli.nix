{ pkgs, self, ... }: {
  programs.zsh.enable = true;

  # gpg + agent for pass / git-credential-manager. Terminal pinentry so
  # prompts work over ssh; ~/.gnupg/gpg-agent.conf (chezmoi) sets the same.
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

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
      git
      rust-analyzer
      python3Packages.pynvim
      nh
    ]);
}
