{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./disk.nix
    ./home.nix
  ];

  # Use systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Configure networking.
  networking = {
    hostName = "seven";
    networkmanager.enable = true;
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = builtins.attrValues { inherit (pkgs) vim wget; };

  powerManagement.powertop.enable = true;

  services.borgbackup.repos = {
    data = {
      path = "/var/lib/borgbackup/data";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIUf4gvsMDgo6nsoS2AnT+X+ZYnLC92pGbe/x0ZvTMQ borg@data" ];
    };
    troi = {
      path = "/var/lib/borgbackup/troi";
      authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGOsM0SFfJ8yV93x9PoHLAckp4e9uhYb4HRgz8ZyMsV5 borg@troi" ];
    };
  };

  nix.gc.options = "--delete-older-than 8w";

  system = {
    autoUpgrade = {
      enable = true;
      dates = "Tue 05:00";
      flake = "github:m00wl/nixfiles";
      runGarbageCollection = true;
    };
    stateVersion = "25.05";
  };
}
