{ config, pkgs, ... }:

{
  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    ports = [ 22 ];
  };
}
