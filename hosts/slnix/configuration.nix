{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/core.nix
    ];

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define hostname
  networking.hostName = "slnix";
  networking.hostId = "75875b34";

  # Set time zone
  time.timeZone = "Europe/Amsterdam";

  # Enable DHCP 
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.enp2s0.useDHCP = true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  system.stateVersion = "21.11";
}
