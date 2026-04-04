{ inputs, self, ... }: {
  flake.nixosConfigurations = {
    nixos-vm = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs self; };
      modules = [
        ../hosts/nixos-vm
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs self; };
        }
      ];
    };
  };
}
