{ config, pkgs, ... }:

{
  imports = [
    #./src/gnome.nix
    ./src/vscode.nix
    ./src/coq.nix
  ];

  home.packages = with pkgs; [
    firefox
    bitwarden
  ];
}
