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
  environment.systemPackages = builtins.attrValues { inherit (pkgs) vim wget; };

  services = {
    qemuGuest.enable = true;
    nextcloud = {
      enable = true;
      hostName = "nc.lum.me";
      https = true;
      package = pkgs.nextcloud32;
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
    borgbackup.jobs = {
      nextcloud = {
        paths = config.services.nextcloud.datadir;
        environment.BORG_RSH = "ssh -i /root/borgbackup/id_ed25519_borg_data";
        repo = "borg@seven:.";
        encryption = {
          mode = "repokey";
          passCommand = "cat /root/borgbackup/repopass";
        };
        compression = "auto,lzma";
        readWritePaths = [ config.services.nextcloud.datadir ];
        preHook = ''
          ${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --on
        '';
        postHook = ''
          ${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --off
        '';
        prune.keep = {
          daily = 7;
          weekly = 4;
          monthly = 12;
          yearly = -1;
        };
      };
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
