{ config, pkgs, ... }:

{
  home.username = "m00wl";
  home.homeDirectory = "/home/m00wl";

  home.stateVersion = "21.11";
  programs.home-manager.enable = true;
  manual.manpages.enable = true;
  news.display = "silent";
}
