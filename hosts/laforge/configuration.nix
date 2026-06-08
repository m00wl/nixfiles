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
    hostName = "laforge";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = builtins.attrValues { inherit (pkgs) vim wget; };

  services = {
    qemuGuest.enable = true;
    nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "moritz.lum.me" = {
          enableACME = true;
          forceSSL = true;
          root = "/srv/www/moritz.lum.me";
        };
        "vw.lum.me" = {
          useACMEHost = "moritz.lum.me";
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://troi";
            proxyWebsockets = true;
          };
        };
        "nc.lum.me" = {
          useACMEHost = "moritz.lum.me";
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://data";
          };
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "no-reply@lum.me";
    certs."moritz.lum.me" = {
      extraDomainNames = [
        "vw.lum.me"
        "nc.lum.me"
      ];
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
