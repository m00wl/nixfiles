{ config, pkgs, ... }:

{
  imports = [
    #./src/gnome.nix
    ./src/vscode.nix
  ];

  home.packages = with pkgs; [
    firefox
    bitwarden
    element-desktop
  ];
}
