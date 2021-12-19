{ config, pkgs, ... }:

{

  imports = [
    ./bash.nix
    ./vim.nix
    ./git.nix
    ./tmux.nix
  ];

  home.packages = with pkgs; [

  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.username = "ml";
  home.homeDirectory = "/home/ml";

  home.stateVersion = "21.11";
  programs.home-manager.enable = true;
}
