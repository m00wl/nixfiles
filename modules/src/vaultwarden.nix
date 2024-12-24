{ config, lib, ...}:
let
  cfg = config.services.vaultwarden;
  user = config.users.users.vaultwarden.name;
  group = config.users.groups.vaultwarden.name;
  dmn = "vw.lumme.de";
in
{
  # Enable Vaultwarden password manager.
  services.vaultwarden = {
    enable = true;
    backupDir = "/data/backup/vw";
    config = {
      DOMAIN = "https://" + dmn;
      SIGNUPS_ALLOWED = false;
      WEBSOCKET_ENABLED = true;
      LOGIN_RATELIMIT_SECONDS = 86400;
      LOGIN_RATELIMIT_MAX_BURST = 25;
    };
  };

  # Initialize backup dir.
  systemd.tmpfiles.rules = [
    "d ${cfg.backupDir} 0755 ${user} ${config.users.groups.users.name} -"
  ];

  # Set backup time to 03:00 AM.
  systemd.timers.backup-vaultwarden.timerConfig.OnCalendar = "*-*-* 03:00:00";

  # Add subdomain to base cert.
  security.acme.certs."moritz.lumme.de".extraDomainNames = [ dmn ];

  # Configure reverse proxy.
  services.nginx = {
    virtualHosts."${dmn}" = {
      useACMEHost = "moritz.lumme.de";
      basicAuthFile = lib.mkForce null;
      locations."/" = {
        proxyPass = "http://localhost:8000";
        proxyWebsockets = true;
      };
      locations."/notifications/hub" = {
        proxyPass = "http://localhost:3012";
        proxyWebsockets = true;
      };
      locations."/notifications/hub/negotiate" = {
        proxyPass = "http://localhost:8000";
        proxyWebsockets = true;
      };
    };
  };
}
