{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../shared/nixos/cli.nix
    ../../shared/nixos/keyboard.nix
  ];

  # Default keyboard layout for this host (German)
  keyboard.layout = "de";
  keyboard.consoleKeyMap = "de";

  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    configurationLimit = 3;
  };

  networking.hostName = "nixos-vm";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  users.users.ghaith = {
    isNormalUser = true;
    description = "Ghaith Hachem";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager.users.ghaith = {
    imports = [ ../../shared/home/chezmoi.nix ];
    home.stateVersion = "25.11";
    chezmoi.enable = true;
  };

  services.openssh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
