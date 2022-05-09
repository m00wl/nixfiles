{ config, pkgs, ... }:

{
  imports = [
    ./src/bash.nix
    ./src/ssh.nix
    ./src/vim.nix
    ./src/git.nix
    ./src/tmux.nix
    ./src/gpg.nix
  ];

  home.packages = with pkgs; [
    gopass
  ];
}
