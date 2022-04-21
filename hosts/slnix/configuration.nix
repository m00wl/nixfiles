{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/core.nix
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

  # Define hostname
  networking.hostName = "slnix";
  networking.hostId = "c416237d";

  # Set time zone
  time.timeZone = "Europe/Amsterdam";

  # Enable DHCP 
  networking.interfaces.eth0.useDHCP = true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  system.stateVersion = "21.11";
}
