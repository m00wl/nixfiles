{ config, lib, ... }:
{
  services.fail2ban = {
    enable = true;
    jails = {
      nginx-auth.settings = {
        enabled = lib.boolToString config.services.nginx.enable;
        port = "http,https";
        filter = "nginx-auth";
        maxretry = 25;
        backend = "systemd";
        journalmatch = "_SYSTEMD_UNIT=nginx.service";
      };
      vaultwarden-auth.settings = {
        #enabled = lib.boolToString config.services.vaultwarden.enable;
        enabled = false;
        port = "http,https";
        filter = "vaultwarden-auth";
        maxretry = 3;
        bantime = 86400;
        backend = "systemd";
        journalmatch = "_SYSTEMD_UNIT=vaultwarden.service";
      };
    };
  };
  environment.etc = {
    "fail2ban/filter.d/nginx-auth.conf" = {
      enable = config.services.nginx.enable;
      text = ''
        [Definition]
        failregex=\[error\] \d+#\d+: \*\d+ user "(?:[^"]+|.*?)":? (?:password mismatch|was not found in "[^\"]*"), client: <HOST>, server:
                  \[info\] \d+#\d+: \*\d+ (?:no user/password was provided for basic authentication), client: <HOST>, server:

        ignoreregex =
      '';
    };
    "fail2ban/filter.d/vaultwarden-auth.conf" = {
      enable = config.services.vaultwarden.enable;
      text = ''
        [Definition]
        failregex=\[vaultwarden::api::identity\]\[ERROR\] Username or password is incorrect\. Try again\. IP: <HOST>\. Username:

        ignoreregex =
      '';
    };
  };
}
