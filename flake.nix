{
  description = "m00wl's flake for NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix }: {
    nixosConfigurations = {
      vlnix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/vlnix/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users = {
              m00wl.imports = [
                ./hosts/vlnix/home-m00wl.nix
              ];
            };
          }
          sops-nix.nixosModules.sops
        ];
      };

      slnix = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/slnix/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users = {
              m00wl.imports = [
                ./hosts/slnix/home-m00wl.nix
              ];
              zeus.imports = [
                ./hosts/slnix/home-zeus.nix
              ];
            };
          }
          sops-nix.nixosModules.sops
        ];
      };

      nlnix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nlnix/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users = {
              m00wl.imports = [
                ./hosts/nlnix/home-m00wl.nix
              ];
            };
          }
          sops-nix.nixosModules.sops
        ];
      };
    };
  };
}
