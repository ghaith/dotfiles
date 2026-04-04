{ config, lib, pkgs, ... }:

let
  cfg = config.keyboard;
in {
  options.keyboard = {
    layout = lib.mkOption {
      type = lib.types.str;
      default = "de";
      description = "XKB keyboard layout (e.g. 'de', 'eu', 'us')";
    };

    variant = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "XKB layout variant (e.g. 'nodeadkeys')";
    };

    consoleKeyMap = lib.mkOption {
      type = lib.types.str;
      default = "de";
      description = "Console/TTY keymap";
    };
  };

  config = {
    console.keyMap = cfg.consoleKeyMap;

    services.xserver.xkb = {
      layout = cfg.layout;
      variant = cfg.variant;
    };
  };
}
