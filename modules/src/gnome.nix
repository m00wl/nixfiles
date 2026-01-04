{ pkgs, ... }:

{
  # Enable GDM + GNOME.
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
