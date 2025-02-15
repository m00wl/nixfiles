{ config, pkgs, lib, ... }:
let
  cfg = config.services.gitea;
  dmn = "git.lumme.de";
in
{
  # Create user and group according to cfg.
  users = {
    users.${cfg.user} = {
      description = "Gitea User";
      home = cfg.stateDir;
      useDefaultShell = true;
      group = cfg.group;
      isSystemUser = true;
    };

    groups.${cfg.group} = {};
  };

  # Configure gitea service.
  services.gitea = {
    enable = true;
    user = "git";
    group = "git";
    appName = "${dmn}: Gitea Service";
    settings = {
      server = {
        DOMAIN = dmn;
        ROOT_URL = "https://" + dmn;
      };
      service = {
        DEFAULT_KEEP_EMAIL_PRIVATE = true;
        DISABLE_REGISTRATION = true;
        ENABLE_BASIC_AUTHENTICATION = false;
      };
      session.COOKIE_SECURE = true;
    };
    database.passwordFile = "/var/lib/gitea/dbpassword";
    dump = {
      enable = true;
      file = "gitea-dump";
      backupDir = "/data/backup/gitea";
      interval = "03:00";
    };
  };

  # Add subdomain to base cert.
  security.acme.certs."moritz.lumme.de".extraDomainNames = [ dmn ];

  # Configure reverse proxy.
  services.nginx.virtualHosts.${dmn} = {
    useACMEHost = "moritz.lumme.de";
    basicAuthFile = lib.mkForce null;
    locations."/" = {
      proxyPass = "http://localhost:${toString cfg.settings.server.HTTP_PORT}/";
      extraConfig = ''
        client_max_body_size 512M;
        proxy_set_header Connection $http_connection;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };
}
