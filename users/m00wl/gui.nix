{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    firefox
    bitwarden-desktop
    element-desktop
    zotero
    libreoffice
  ];
}
