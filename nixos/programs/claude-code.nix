{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.claude-code = inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
  };
}
