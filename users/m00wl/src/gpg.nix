{ pkgs, ... }:
{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  home.packages = builtins.attrValues {
    inherit (pkgs) pinentry;
  };
}
