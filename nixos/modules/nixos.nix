{ inputs, ... }: {
  flake.nixosConfigurations = {
    nixos-vm = inputs.nixpkgs.lib.nixosSystem {
      modules = [ ../hosts/nixos-vm ];
    };
  };
}
