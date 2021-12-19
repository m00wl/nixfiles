{ config, pkgs, ... }:

{

  imports = [
    ./vim.nix
  ];

  home.packages = with pkgs; [
      vim
      tmux
      git
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.username = "ml";
  home.homeDirectory = "/home/ml";

  home.stateVersion = "21.11";
  programs.home-manager.enable = true;
}
