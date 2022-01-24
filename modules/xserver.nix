{ config, pkgs, ... }:

{
  # Enable X11 server
  services.xserver = {
    enable = true;
    layout = "de";
  };
}
