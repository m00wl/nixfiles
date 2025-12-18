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
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      };
  };

  # Configure networking.
  networking = {
    hostName = "data";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 80 ];
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
    vim
    wget;
  };

  services = {
    qemuGuest.enable = true;
    nextcloud = {
      enable = true;
      hostName = "nc.lum.me";
      https = true;
      package = pkgs.nextcloud31;
      config = {
        dbtype = "sqlite";
        adminpassFile = "/etc/nextcloud-admin-pass";
      };
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps)
        contacts
        calendar;
      };
    };
  };

  system.stateVersion = "25.05";
}
