{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.tuicr = inputs.tuicr.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
}
