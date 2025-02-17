{ pkgs, ... }:

{
  # Import X11 server config.
  imports = [
    ./xserver.nix
  ];

  # Enable GDM + GNOME.
  services = {
    xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
