{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/core.nix
      ../../modules/gui.nix
    ];

  # Use systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define hostname
  networking.hostName = "vlnix";
  networking.hostId = "65809531";

  # Set time zone
  time.timeZone = "Europe/Amsterdam";

  # Enable DHCP
  networking.interfaces.enp0s3.useDHCP = true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  system.stateVersion = "21.11";
}
