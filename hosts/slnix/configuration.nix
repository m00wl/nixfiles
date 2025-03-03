{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./home-configuration.nix
      ./backup.nix
      ../../modules/src/zfs.nix
      ../../modules/src/rpi.nix
      ../../modules/src/zeus.nix
      ../../modules/src/nginx.nix
      ../../modules/src/fail2ban.nix
      ../../modules/src/gitea.nix
      ../../modules/src/vaultwarden.nix
      ../../modules/src/radicale.nix
      ../../modules/src/charl00w.nix
    ];

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  # Configure networking for DMZ.
  networking = {
    hostName = "slnix";
    hostId = "c416237d";
    useDHCP = false;
    domain = "lumme.de";
    dhcpcd.enable = false;
    enableIPv6 = false;
    vlans = {
      vlan11 = {
        id = 11;
        interface = "eth0";
      };
    };
    interfaces.vlan11.ipv4.addresses = [
      { address = "192.168.11.20"; prefixLength = 24; }
    ];
    defaultGateway = "192.168.11.1";
    nameservers = [
      "192.168.11.1"
    ];
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  system.stateVersion = "21.11";
}
