{ config, pkgs, lib, ...}:

{
  config.networking.firewall.allowedTCPPorts = [ 80 ];

  # Retrieve htpasswd from sops-nix
  config.sops.secrets."nginx.service/lumme.de.htpasswd" = {
    sopsFile = ../../hosts/slnix/secrets.yaml;
    owner = config.services.nginx.user;
    group = config.services.nginx.group;
  };

  # Make all virtualHosts default to http basic auth
  options.services.nginx.virtualHosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      basicAuthFile = "/run/secrets/nginx.service/lumme.de.htpasswd";
    });
  };
  
  config.services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    logError = "stderr info";
    #appendHttpConfig = ''
    #  auth_basic secured;
    #  auth_basic_user_file /nix/store/l7h8anz7prabk1y0zd6kbj068n4v18wr-example.com.htpasswd;
    #'';
    virtualHosts."example.com" = {
      basicAuth = { test = "test123"; };
    };
  };

  #security.acme = {
  #  acceptTerms = true;
  #  email = "contact@moritz.lumme.de";
  #};
}
