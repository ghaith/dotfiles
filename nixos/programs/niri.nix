{ inputs, lib, self, ... }: {
  perSystem = { pkgs, ... }: {
    packages.niri-desktop = pkgs.symlinkJoin {
      name = "niri-desktop";
      paths = with pkgs; [
        # desktop shell
        dms-shell

        # notifications
        mako

        # launcher
        fuzzel

        # wayland / clipboard
        wl-clipboard
        xclip

        # idle & wallpaper
        swayidle
        swaybg
      ];
    };
  };

  # Niri-specific systemd user services (NixOS-level)
  flake.nixosModules.niri-services = { pkgs, ... }: {
    systemd.user.services.swayidle = {
      description = "Idle manager for Wayland (swayidle)";
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 300 '${pkgs.dms-shell}/bin/dms ipc call lock lock' timeout 600 'niri msg action power-off-monitors' resume 'niri msg action power-on-monitors'";
        Restart = "on-failure";
        RestartSec = 3;
      };
    };

    systemd.user.services.swaybg = {
      description = "Set the wallpaper with swaybg";
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      requires = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "%h/.local/scripts/changebg.sh";
        Restart = "no";
      };
      path = [ pkgs.swaybg pkgs.procps ];
    };

    systemd.user.timers.swaybg = {
      description = "Change wallpaper every 10 minutes";
      requires = [ "swaybg.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2min";
        OnUnitActiveSec = "10min";
        Persistent = true;
      };
    };
  };
}
