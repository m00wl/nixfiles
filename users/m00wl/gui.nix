{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
    firefox
    bitwarden-desktop
    element-desktop
    zotero
    libreoffice;
  };
}
