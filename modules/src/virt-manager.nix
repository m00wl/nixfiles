{ config, pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  home-manager.users.m00wl = {
    home.packages = with pkgs; [ virt-manager ];
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
  users.users.m00wl.extraGroups = [ "libvirtd" ];
}
