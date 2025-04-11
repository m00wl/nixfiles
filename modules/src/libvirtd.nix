{ pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;
  users.users.m00wl.extraGroups = [ "libvirtd" ];
}
