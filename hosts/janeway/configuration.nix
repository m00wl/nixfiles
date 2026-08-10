{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./disk.nix
    ./home.nix
  ];

  # Use systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Configure networking.
  networking = {
    hostName = "janeway";
    networkmanager.enable=true;
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = builtins.attrValues { inherit (pkgs) vim wget; };

  # enable touchpad support.
  services.libinput.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  system.stateVersion = "26.05";
}
