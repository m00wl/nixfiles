{ config, pkgs, lib, ...}:

let
  cfg = config.services.vaultwarden;
  user = config.users.users.vaultwarden.name;
  group = config.users.groups.vaultwarden.name;
in
{
  # Enable Vaultwarden password manager
  services.vaultwarden = {
    enable = true;
    backupDir = "/data/backup/vw";
    config = {
      domain = "https://vw.lumme.de";
      signupsAllowed = false;
      websocketEnabled = true;
    };
  };

  # Initialize backup dir
  systemd.tmpfiles.rules = [
    "d ${cfg.backupDir} 0755 ${user} ${config.users.groups.users.name} -"
  ];

  # Change backup time to 03 AM
  systemd.timers.backup-vaultwarden.timerConfig.OnCalendar = "*-*-* 03:00:00";

  # Add subdomain to base cert
  security.acme.certs."moritz.lumme.de".extraDomainNames = [ "vw.lumme.de" ];

  # Configure reverse proxy
  services.nginx = {
    virtualHosts."vw.lumme.de" = {
      useACMEHost = "moritz.lumme.de";
      forceSSL = true;
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
