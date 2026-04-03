{ inputs, ... }: {
  flake.nixosConfigurations = {
    nixos-vm = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ../hosts/nixos-vm ];
    };
  };
}
