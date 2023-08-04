{ config, pkgs, ... }:

{

  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "ghaith";
    homeDirectory = "/home/ghaith";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";

    # Development
    packages = with pkgs; [
      gh
      git
      helix
      neovim
      ripgrep
      jq
    ];
    sessionVariables = {
      EDITOR = "hx";
    };
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


}
