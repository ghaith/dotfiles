{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # wayland / clipboard
    wl-clipboard
    xclip

    # launcher
    fuzzel

    # fonts
    (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" "Hack" "JetBrainsMono" ]; })
  ];
}
