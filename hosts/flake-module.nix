{ self, inputs, config, ... }:
let
  commonNixosModules = [

    # Common inputs.
    inputs.home-manager.nixosModules.home-manager

    # Base system configuration.
    self.nixosModules.base

    # Make 'self' available to nixosModules.
    { config._module.args.self = self; }
  ];
in
{
  flake = {

    nixosConfigurations = {
      blnix = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [ ./blnix/configuration.nix ];
      };
      nlnix = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          ./nlnix/configuration.nix
          self.nixosModules.gui
        ];
      };
      slnix = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [ ./slnix/configuration.nix ];
      };
      vlnix = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          ./vlnix/configuration.nix
          inputs.disko.nixosModules.disko
          self.nixosModules.gui
        ];
      };
    };

  };
}
