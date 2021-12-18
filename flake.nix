{
  description = "My NixOS configurations flake";

  outputs = { self, nixpkgs }: {

    nixosConfigurations = {

      vlnix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/vlnix/configuration.nix
        ];
      };
    };

  };
}
