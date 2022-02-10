{ config, pkgs, ... }:

{
  imports = [
    ./src/flakes.nix
    ./src/gc.nix
    ./src/zfs.nix
    ./src/i18n.nix
    ./src/m00wl.nix
    ./src/openssh.nix
  ];
}
