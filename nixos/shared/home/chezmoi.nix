{ config, lib, pkgs, ... }: {
  # Apply chezmoi dotfiles during home-manager activation.
  # The chezmoi source is the dotfiles repo (parent of nixos/).
  # On NixOS, nixos-rebuild switch triggers this via home-manager.

  options.chezmoi = {
    enable = lib.mkEnableOption "chezmoi dotfile management";
    source = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/dotfiles";
      description = "Path to the chezmoi source directory";
    };
    type = lib.mkOption {
      type = lib.types.enum [ "desktop" "server" "devcontainer" ];
      default = "server";
      description = "Machine type for chezmoi templating";
    };
    name = lib.mkOption {
      type = lib.types.str;
      default = "Ghaith Hachem";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "git@mail.hachem.at";
    };
  };

  config = lib.mkIf config.chezmoi.enable {
    home.packages = [ pkgs.chezmoi ];

    # Write chezmoi config so templates resolve without prompts
    home.file.".config/chezmoi/chezmoi.toml".text = ''
      sourceDir = "${config.chezmoi.source}"

      [data]
          interactive = false
          type = "${config.chezmoi.type}"
          name = "${config.chezmoi.name}"
          email = "${config.chezmoi.email}"
    '';

    home.activation.chezmoi = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -d "${config.chezmoi.source}" ]; then
        run ${pkgs.chezmoi}/bin/chezmoi apply \
          --source "${config.chezmoi.source}" \
          --no-tty \
          --force \
          2>&1 || echo "chezmoi apply failed, continuing..."
      else
        echo "chezmoi source not found at ${config.chezmoi.source}, skipping"
      fi
    '';
  };
}
