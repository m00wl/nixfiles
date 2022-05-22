{ config, pkgs, ...}:

let
  backupDir = "/data/backup/vw";
in
{
  services.vaultwarden = {
    enable = true;
    backupDir = backupDir;
    config = {
      domain = "https://vw.lumme.de";
      signupsAllowed = true;
      websocketEnabled = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d ${backupDir} 0755 ${toString config.users.users.vaultwarden.name} ${toString config.users.groups.users.name} -"
  ];

  services.nginx = {
    virtualHosts."vw.lumme.de" = {
      #forceSSL = true;
      #enableACME = true;
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
