{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    firefox
    thunderbird
    bitwarden
    element-desktop
    zotero
    libreoffice
  ];
}
