{ self, lib, ... }:
{
  nix = {

    # Enable flakes.
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Pin nixpkgs in system registry to version of nixpkgs flake input.
    registry.nixpkgs.flake = self.inputs.nixpkgs;
  };
}
