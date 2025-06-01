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
      cochrane = inputs.nixpkgs.lib.nixosSystem {
        modules = [ ./cochrane/configuration.nix ];
      };
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
      q = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          ./q/configuration.nix
          inputs.disko.nixosModules.disko
        ];
      };
      troi = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          ./troi/configuration.nix
          inputs.disko.nixosModules.disko
        ];
      };
      doctor = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          ./doctor/configuration.nix
          inputs.disko.nixosModules.disko
          self.nixosModules.gui
        ];
      };
      dax = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          inputs.nixos-hardware.nixosModules.common-pc
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          ./dax/configuration.nix
          inputs.disko.nixosModules.disko
          self.nixosModules.gui
        ];
      };
    };

  };
}
