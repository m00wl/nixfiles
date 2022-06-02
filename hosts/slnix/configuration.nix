{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/core.nix
      ../../modules/src/zeus.nix
      ../../modules/src/nginx.nix
      ../../modules/src/fail2ban.nix
      ../../modules/src/git-server.nix
      ../../modules/src/vaultwarden.nix
      ../../modules/src/radicale.nix
    ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enable the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.blacklistedKernelModules = [
    # disable wifi
    "brcmfmac" "brcmutil" "cfg80211" "rfkill"
    # disable bt
    "btbcm" "hci_uart" "ecc" "ecdh_generic" "bluetooth"
    # disable i2c
    "i2c-bcm2835"
  ];
  boot.plymouth.enable = true;

  # Configure networking for DMZ
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

  # Set time zone
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  system.stateVersion = "21.11";
}
