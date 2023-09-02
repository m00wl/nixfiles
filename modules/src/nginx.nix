{ config, pkgs, lib, ...}:
{
  # virtualHost defaults:
  # https redirect
  # http basic auth
  options.services.nginx.virtualHosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      forceSSL = true;
      basicAuthFile = "/run/secrets/nginx/htpasswd";
    });
  };

  config = {

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    # Retrieve htpasswd from sops-nix.
    sops.secrets."nginx/htpasswd" = {
      sopsFile = ../../hosts/slnix/secrets.yaml;
      key = "auth/htpasswd";
      owner = config.services.nginx.user;
      group = config.services.nginx.group;
    };


    services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # fail2ban needs at least this logging level.
      logError = "stderr info";

      # m00wl's personal website.
      virtualHosts."moritz.lumme.de" = {
        enableACME = true;
        root = "/var/www/moritz.lumme.de";
        basicAuthFile = lib.mkForce null;
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "acme@moritz.lumme.de";
      certs."moritz.lumme.de" = {};
    };

  };
}
