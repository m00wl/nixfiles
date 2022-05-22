{ config, pkgs, lib, ...}:

{
  services.fail2ban = {
    enable = true;
    jails = {
      nginx-auth = ''
        enabled       = ${lib.boolToString config.services.nginx.enable}
        port          = http,https
        filter        = nginx-auth
        backend       = systemd
        journalmatch  = _SYSTEMD_UNIT=nginx.service
      '';
    };
  };
  environment.etc."fail2ban/filter.d/nginx-auth.conf" = {
    enable = config.services.nginx.enable;
    text = ''
      [Definition]
      failregex=\[error\] \d+#\d+: \*\d+ user "(?:[^"]+|.*?)":? (?:password mismatch|was not found in "[^\"]*"), client: <HOST>, server:
                \[info\] \d+#\d+: \*\d+ (?:no user/password was provided for basic authentication), client: <HOST>, server:

      ignoreregex =
    '';
  };
}
