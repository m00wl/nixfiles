{ self, inputs, config, ... }:
{
  perSystem = { config, self', inputs', pkgs, system, ... }: {
    packages.self-flake = (import ./src/self-flake.nix) { inherit pkgs; };
  };
}
