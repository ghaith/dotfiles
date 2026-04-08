{ pkgs, self, inputs, ... }: {
  imports = [ self.nixosModules.niri-services ];

  # Window manager
  programs.niri.enable = true;

  # Desktop shell — DMS with systemd autostart
  programs.dms-shell = {
    enable = true;
    systemd.enable = true;
    quickshell.package = pkgs.quickshell;
  };

  # Display manager — DankGreeter
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    quickshell.package = pkgs.quickshell;
  };

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

  # XDG portal for niri (screen sharing, file picker, etc.)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
  };

  # Fonts
  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    iosevka
    hack
    jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    # niri desktop environment
    self.packages.${pkgs.stdenv.hostPlatform.system}.niri-desktop

    # terminals
    ghostty
    kitty
    alacritty

    # browsers
    vivaldi

    # SSH askpass (GUI prompt for passphrase)
    kdePackages.ksshaskpass
  ];
}
