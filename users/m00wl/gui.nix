{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      firefox
      # TODO: uncomment once unblocked by: https://github.com/nixos/nixpkgs/issues/526914
      #bitwarden-desktop
      element-desktop
      zotero
      libreoffice
      ;
  };
}
