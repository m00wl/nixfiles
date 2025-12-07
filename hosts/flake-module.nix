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
      nlnix = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          inputs.nixos-hardware.nixosModules.common-pc-laptop
          inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          ./nlnix/configuration.nix
          self.nixosModules.gui
        ];
      };
      doctor = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          ./doctor/configuration.nix
          inputs.disko.nixosModules.disko
          self.nixosModules.gui
        ];
      };
      blnix = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [ ./blnix/configuration.nix ];
      };
      slnix = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [ ./slnix/configuration.nix ];
      };
      sisko = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          inputs.nixos-hardware.nixosModules.common-pc
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          ./sisko/configuration.nix
          inputs.disko.nixosModules.disko
        ];
      };
      cochrane = inputs.nixpkgs.lib.nixosSystem {
        modules = [ ./cochrane/configuration.nix ];
      };
      q = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          inputs.nixos-hardware.nixosModules.common-pc
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          ./q/configuration.nix
          inputs.disko.nixosModules.disko
        ];
      };
      laforge = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          ./laforge/configuration.nix
          inputs.disko.nixosModules.disko
        ];
      };
      troi = inputs.nixpkgs.lib.nixosSystem {
        modules = commonNixosModules ++ [
          ./troi/configuration.nix
          inputs.disko.nixosModules.disko
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
