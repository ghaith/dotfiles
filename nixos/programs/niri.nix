{ inputs, lib, self, ... }: {
  perSystem = { pkgs, ... }: {
    packages.niri-desktop = pkgs.symlinkJoin {
      name = "niri-desktop";
      paths = with pkgs; [
        # notifications
        mako

        # launcher
        fuzzel

        # wayland / clipboard
        wl-clipboard
        xclip
        cliphist

        # idle, lock & wallpaper
        swayidle
        swaylock
        swaybg

        # tools
        wdisplays
        wireplumber           # wpctl
        cups-pk-helper
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
        ExecStart = let
          dms = "${pkgs.dms-shell}/bin/dms";
          niri = "${pkgs.niri}/bin/niri";
          lock = "${dms} ipc call lock lock";
        in toString [
          "${pkgs.swayidle}/bin/swayidle -w"
          "timeout 300 '${lock}'"
          "timeout 600 '${niri} msg action power-off-monitors'"
          "resume '${niri} msg action power-on-monitors'"
          "timeout 900 'if [ \"$(cat /sys/class/power_supply/AC*/online 2>/dev/null || echo 1)\" = \"0\" ]; then systemctl suspend; fi'"
          "before-sleep '${lock}'"
        ];
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
