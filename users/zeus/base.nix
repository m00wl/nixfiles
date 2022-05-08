{ config, pkgs, ... }:

{
  home.username = "zeus";
  home.homeDirectory = "/home/zeus";

  home.stateVersion = "21.11";
  programs.home-manager.enable = true;
}
