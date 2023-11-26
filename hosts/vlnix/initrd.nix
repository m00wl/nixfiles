{ config, ... }:
let
  keys = config.users.users.m00wl.openssh.authorizedKeys.keys;
in
{
  boot = {
    initrd = {
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 22;
          shell = "/bin/cryptsetup-askpass";
          authorizedKeys = keys;
          hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
        };
      };
      availableKernelModules = [ "e1000" ];
    };
    kernelParams = [ "ip=dhcp" ];
  };
}
