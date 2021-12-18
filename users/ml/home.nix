{ configs, pkgs, ... }:

{
  home.username = "ml";
  home.homeDirectory = "/home/ml";
  
  home.stateVersion = "21.11";
  programs.home-manager.enable = true;
}
