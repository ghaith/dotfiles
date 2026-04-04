{ pkgs, self, ... }: {
  imports = [ self.nixosModules.niri-services ];
  # Window manager
  programs.niri.enable = true;

  # Display manager
  services.xserver.enable = true;
  services.displayManager.defaultSession = "niri";

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
  ];
}
