{ config, pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./ssh.nix
    ./vim.nix
    ./git.nix
    ./tmux.nix
  ];

  home.packages = with pkgs; [

  ];
}
