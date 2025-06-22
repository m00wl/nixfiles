{
  description = "m00wl's nixfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hosts/flake-module.nix
        ./modules/flake-module.nix
        ./packages/flake-module.nix
        ./users/flake-module.nix
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        formatter = pkgs.nixfmt;
      };
    };
}
