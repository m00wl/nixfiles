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
          extraConfig = ''
            index index.php index.html /index.php$request_uri;
            add_header X-Content-Type-Options nosniff;
            add_header X-Robots-Tag "noindex, nofollow";
            add_header X-Permitted-Cross-Domain-Policies none;
            add_header X-Frame-Options sameorigin;
            add_header Referrer-Policy no-referrer;
            add_header Strict-Transport-Security "max-age=15552000; includeSubDomains" always;
            client_max_body_size 512M;
            fastcgi_buffers 64 4K;
            fastcgi_hide_header X-Powered-By;
            gzip on;
            gzip_vary on;
            gzip_comp_level 4;
            gzip_min_length 256;
            gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
            gzip_types application/atom+xml text/javascript application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/wasm application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;
          '';
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "no-reply@lum.me";
    certs."moritz.lum.me" = {
      extraDomainNames = [ "vw.lum.me" "nc.lum.me" ];
    };
  };

  system.stateVersion = "25.05";
}
