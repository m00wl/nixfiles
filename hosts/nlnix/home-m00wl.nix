{ config, pkgs, ... }:

{
  imports = [
    ../../users/m00wl/base.nix
    ../../users/m00wl/cli.nix
    ../../users/m00wl/gui.nix
  ];
}
