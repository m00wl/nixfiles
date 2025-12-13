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
    firewall.allowedTCPPorts = [ 80 443 ];
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
            proxyPass = "http://troi:8000";
            proxyWebsockets = true;
          };
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "no-reply@lum.me";
    certs."moritz.lum.me" = {
      extraDomainNames = [ "vw.lum.me" ];
    };
  };

  system.stateVersion = "25.05";
}
