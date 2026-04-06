{ pkgs, ... }:
{
  imports = [
    ./libvirtd.nix
  ];

  programs.dconf.enable = true;
  home-manager.users.m00wl = {
    home.packages = builtins.attrValues { inherit (pkgs) virt-manager; };
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}
