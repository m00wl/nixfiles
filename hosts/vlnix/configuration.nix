{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko-configuration.nix { _module.args.disks = [ "/dev/sda" ]; }
    ./home-configuration.nix
  ];

  # Use systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Configure networking.
  networking = {
    hostName = "vlnix";
    hostId = "65809531";
    networkmanager.enable = true;
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
