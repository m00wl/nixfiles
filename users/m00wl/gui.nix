{ config, pkgs, ... }:
{
  imports = [
    ./src/vscode.nix
  ];

  home.packages = with pkgs; [
    firefox
    bitwarden
    element-desktop
  ];
}
