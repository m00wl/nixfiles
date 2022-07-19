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
  networking.hostName = "nlnix";
  networking.hostId = "b028b71c";

  # Set time zone
  time.timeZone = "Europe/Amsterdam";

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  system.stateVersion = "22.05";
}
