{ config, pkgs, ... }:

{
  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
