{ self, inputs, ... }:
let
  commonNixosModules = [

    # Common inputs.
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko

    # Base system configuration.
    self.nixosModules.base

    # Make 'self' available to nixosModules.
    { config._module.args.self = self; }
  ];
in
{
  flake = {

    nixosConfigurations = {
      janeway = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          inputs.nixos-hardware.nixosModules.common-pc-laptop
          inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-gpu-intel
          ./janeway/configuration.nix
          self.nixosModules.gui
        ];
      };
      doctor = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          ./doctor/configuration.nix
          self.nixosModules.gui
        ];
      };
      sisko = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          inputs.nixos-hardware.nixosModules.intel-nuc-7i3bnb
          ./sisko/configuration.nix
        ];
      };
      cochrane = inputs.nixpkgs.lib.nixosSystem {
        modules = [ ./cochrane/configuration.nix ];
      };
      seven = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          inputs.nixos-hardware.nixosModules.intel-nuc-7i3bnb
          ./seven/configuration.nix
        ];
      };
      queen = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          ./queen/configuration.nix
        ];
      };
      q = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          inputs.nixos-hardware.nixosModules.intel-nuc-7i3bnb
          ./q/configuration.nix
        ];
      };
      laforge = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          ./laforge/configuration.nix
        ];
      };
      troi = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          ./troi/configuration.nix
        ];
      };
      data = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          ./data/configuration.nix
        ];
      };
    };
  };
}
