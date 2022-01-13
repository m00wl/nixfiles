{
  description = "m00wl's flake for NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: {

    nixosConfigurations = {

      vlnix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/vlnix/configuration.nix
          home-manager.nixosModules.home-manager {

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.m00wl = import ./users/m00wl/home.nix;
          }
        ];
      };

      slnix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/slnix/configuration.nix
          home-manager.nixosModules.home-manager {
      
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.m00wl = import ./users/m00wl/home.nix;
          }
        ];
      };

    };

  };
}
