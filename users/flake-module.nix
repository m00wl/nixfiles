{ self, inputs, config, ... }:
{
  flake = {

    homeModules = { 
      default = self.homeModules.cli;
      m00wl = { imports = [ ./m00wl/base.nix ]; };
      zeus = { imports = [ ./zeus/base.nix ]; };
      cli = { imports = [ ./m00wl/cli.nix ]; };
      gui = { imports = [ ./m00wl/gui.nix ]; };
    };

    homeConfigurations = {
      default = self.homeConfigurations.cli;
      cli = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
        modules = with self.homeModules; [ m00wl cli ];
      };
      full = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
        modules = with self.homeModules; [ m00wl cli gui ];
      };
    };

  };
}
