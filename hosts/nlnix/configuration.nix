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

  # Configure networking
  networking.hostName = "nlnix";
  networking.hostId = "737e8eaa";
  networking.networkmanager.enable = true;

  # Set time zone
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  system.stateVersion = "22.05";
}
