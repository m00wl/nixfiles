{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      firefox
      libreoffice
      ;
  };
}
