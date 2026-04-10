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
    hostName = "troi";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 80 ];
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = builtins.attrValues { inherit (pkgs) vim wget; };

  services = {
    qemuGuest.enable = true;
    vaultwarden = {
      enable = true;
      backupDir = "/var/backup/vaultwarden";
      environmentFile = "/etc/vaultwarden.env";
      config = {
        DOMAIN = "https://vw.lum.me";
        SIGNUPS_ALLOWED = false;
        _ENABLE_SMTP = false;
      };
    };
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "vw.lum.me" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8000";
            proxyWebsockets = true;
          };
        };
      };
    };
    borgbackup.jobs = {
      vaultwarden = {
        paths = config.services.vaultwarden.backupDir;
        environment.BORG_RSH = "ssh -i /root/borgbackup/id_ed25519_borg_troi";
        repo = "borg@seven:.";
        encryption = {
          mode = "repokey";
          passCommand = "cat /root/borgbackup/repopass";
        };
        compression = "auto,lzma";
        prune.keep = {
          daily = 7;
          weekly = 4;
          monthly = 12;
          yearly = -1;
        };
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
      runGarbageCollection = true;
    };
    stateVersion = "25.05";
  };
}
