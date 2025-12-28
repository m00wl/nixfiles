{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./disk.nix
    ./home.nix
  ];

  # Use systemd-boot EFI boot loader.
  boot = {
    kernelParams = [
      "vga=0x317"
      "nomodeset"
    ];
    loader.systemd-boot.enable = true;
  };

  # Configure networking.
  networking = {
    hostName = "queen";
    networkmanager.enable = true;
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = builtins.attrValues { inherit (pkgs) vim wget; };

  services = {
    qemuGuest.enable = true;
  };

  system.stateVersion = "25.05";
}
