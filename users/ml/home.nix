{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
      tmux
      git
  ];

  home.username = "ml";
  home.homeDirectory = "/home/ml";
  
  home.stateVersion = "21.11";
  programs.home-manager.enable = true;
}
