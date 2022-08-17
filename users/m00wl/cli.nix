{ config, pkgs, ... }:

{
  imports = [
    ./src/bash.nix
    ./src/ssh.nix
    ./src/vim.nix
    ./src/git.nix
    ./src/tmux.nix
  ];
}
