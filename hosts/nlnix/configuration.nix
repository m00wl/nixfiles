{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./home.nix
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

  services.tailscale.enable = true;

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  environment = {
    systemPackages = builtins.attrValues { inherit (pkgs) vim wget; };
    variables = { GSK_RENDERER = "ngl"; };
  };

  # enable touchpad support.
  services.libinput.enable = true;

  system.stateVersion = "22.05";
}
