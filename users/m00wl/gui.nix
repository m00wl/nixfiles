{ config, pkgs, ... }:

{
  imports = [
    ./gnome.nix
  ];

  home.packages = with pkgs; [

  ];
}
