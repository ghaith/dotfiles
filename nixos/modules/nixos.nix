{ inputs, self, ... }: {
  flake.nixosConfigurations = {
    nixos-vm = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs self; };
      modules = [ ../hosts/nixos-vm ];
    };
  };
}
