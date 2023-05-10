{ config, pkgs, ... }:

{
  imports = [
    ./src/flakes.nix
    ./src/current-flake.nix
    ./src/gc.nix
    ./src/i18n.nix
    ./src/m00wl.nix
    ./src/openssh.nix
    ./src/sops.nix
  ];
}
