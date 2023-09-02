{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./home-configuration.nix
    ../../modules/src/zfs.nix
  ];

  # Use systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Configure networking.
  networking = {
    hostName = "nlnix";
    hostId = "737e8eaa";
    networkmanager.enable = true;
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  system.stateVersion = "22.05";
}
