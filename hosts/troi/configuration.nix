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
    hostName = "troi";
    networkmanager.enable = true;
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) vim wget;
  };

  services.qemuGuest.enable = true;
  boot.kernelParams = [ "console=ttyS0,115200" ];

  system.stateVersion = "25.05";
}
