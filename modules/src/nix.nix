{ self, ... }:
{
  nix = {

    # Enable flakes.
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Setup periodic garbage collection.
    gc = {
      automatic = true;
      dates = "weekly";
    };

    # Pin nixpkgs in system registry to version of nixpkgs flake input.
    registry.nixpkgs.flake = self.inputs.nixpkgs;
  };
}
