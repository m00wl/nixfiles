{ config, pkgs, ... }:

{
  # Enable PlatformIO
  home-manager.users.m00wl.home.packages = with pkgs; [ platformio ];

  # Give m00wl permission to read/write IOPorts
  users.users.m00wl.extraGroups = [ "dialout" ];
}
