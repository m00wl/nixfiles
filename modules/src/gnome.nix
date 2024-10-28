{ pkgs, ... }:

{
  # Import X11 server config.
  imports = [
    ./xserver.nix
  ];

  # Enable GDM + GNOME + touchpad support.
  services = {
    xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    libinput.enable = true;
  };
}
