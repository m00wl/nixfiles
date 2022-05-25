{ config, pkgs, lib, ...}:

let
  backupDir = "/data/backup/vw";
in
{
  services.vaultwarden = {
    enable = true;
    backupDir = backupDir;
    config = {
      domain = "https://vw.lumme.de";
      signupsAllowed = false;
      websocketEnabled = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d ${backupDir} 0755 ${toString config.users.users.vaultwarden.name} ${toString config.users.groups.users.name} -"
  ];

  security.acme.certs."moritz.lumme.de".extraDomainNames = [ "vw.lumme.de" ];

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

  # Change backup time to 03 AM
  systemd.timers.backup-vaultwarden.timerConfig.OnCalendar = "*-*-* 03:00:00";
}
