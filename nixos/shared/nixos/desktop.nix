{ pkgs, self, inputs, ... }: {
  imports = [ ];

  # Window manager
  services.desktopManager.plasma6.enable = true;

  # Display manager
  services.displayManager.plasma-login-manager.enable = true;

  # Idle / lock / suspend
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";              # suspend on lid close
    HandleLidSwitchDocked = "ignore";         # ignore lid close when external display connected
    HandleLidSwitchExternalPower = "suspend"; # still suspend on lid close even on AC
  };

  # Printing
  services.printing.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Browsers
  programs.firefox.enable = true;

  # SSH agent — don't enable here, desktop environments (GNOME/GCR)
  # typically provide their own via gcr-ssh-agent.
  # If no DE provides one, enable per-host instead.

  # Fonts
  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    iosevka
    hack
    jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    # terminals
    ghostty
    kitty
    alacritty

    # browsers
    vivaldi
    floorp-bin
  ];
}
