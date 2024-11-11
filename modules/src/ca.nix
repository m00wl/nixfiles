{ config, lib, ... }:
let
  cfg = config.services.step-ca;
  # credentials path must be hardcoded in the config file.
  creds = "/run/credentials/" + config.systemd.services."step-ca".name;
in
{
  # this expects ca.tar.gz extracted to /root/.
  systemd.services."step-ca".serviceConfig = {
    LoadCredential = lib.mkForce [
      "intermediate_password:${cfg.intermediatePasswordFile}"
      "root_cert:/root/ca/certs/root_ca.crt"
      "intermediate_cert:/root/ca/certs/intermediate_ca.crt"
      "intermediate_key:/root/ca/secrets/intermediate_ca_key"
    ];
  };

  services.step-ca = {
    enable = true;
    address = "[::1]";
    port = 443;
    openFirewall = true;
    intermediatePasswordFile = "/root/ca/pwd/intermediate_ca_pwd";
    settings = {
      root = "${creds}/root_cert";
      crt = "${creds}/intermediate_cert";
      key = "${creds}/intermediate_key";
      dnsNames = [ "ca.lum.home" ];
      logger = { format = "text"; };
      db = {
        type = "badgerv2";
        dataSource = "/var/lib/step-ca/db";
        badgerFileLoadingMode = "";
      };
      authority = {
        provisioners = [
          {
            type = "ACME";
            name = "acme";
          }
        ];
      };
      tls = {
        cipherSuites = [
          "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256"
          "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
        ];
        minVersion = 1.2;
        maxVersion = 1.3;
        renegotiation = false;
      };
    };
  };
}
