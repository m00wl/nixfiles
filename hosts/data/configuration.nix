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
      package = pkgs.nextcloud33;
      config = {
        dbtype = "sqlite";
        adminpassFile = "/etc/nextcloud-admin-pass";
      };
      settings = {
        trusted_proxies = [ "192.168.0.3" ];
        overwriteprotocol = "https";
      };
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps)
          contacts
          calendar
          ;
      };
    };
    borgbackup.jobs =
      let
        lock = "/run/borgbackup.lock";
        occ = "${config.services.nextcloud.occ}/bin/nextcloud-occ";
        makeBorgJob = target: {
          paths = config.services.nextcloud.datadir;
          environment.BORG_RSH = "ssh -i /root/borgbackup/id_ed25519_borg_${target}";
          encryption = {
            mode = "repokey";
            passCommand = "cat /root/borgbackup/repopass_${target}";
          };
          compression = "auto,lzma";
          readWritePaths = [
            config.services.nextcloud.datadir
            lock
          ];
          preHook = ''
            exec 200>${lock}
            flock -x 200
            ${occ} maintenance:mode --on
          '';
          postHook = ''
            ${occ} maintenance:mode --off
            exec 200>&-
          '';
          prune.keep = {
            daily = 7;
            weekly = 4;
            monthly = 12;
            yearly = -1;
          };
        };
      in
      {
        nextcloud-seven = (makeBorgJob "seven") // {
          repo = "borg@seven:.";
        };
        nextcloud-queen = (makeBorgJob "queen") // {
          repo = "borg@bak.lum.me:.";
        };
      };
  };

  nix = {
    gc.options = "--delete-older-than 32d";
    optimise = {
      automatic = true;
      dates = "Tue 05:30";
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "Tue 05:00";
      flake = "github:m00wl/nixfiles";
      randomizedDelaySec = "900";
      runGarbageCollection = true;
    };
    stateVersion = "25.05";
  };
}
