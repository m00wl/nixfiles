{ config, ... }:

let
  key = builtins.readFile ../../users/m00wl/id_ed25519_mwl.pub;
in
{
  boot = {
    initrd = {
      availableKernelModules = [ "e1000e" ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 22;
          authorizedKeys = [ ''command="systemctl default" ${key}'' ];
          hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
        };
      };
    };
    kernelParams = [ "ip=::::${config.networking.hostName}::dhcp" ];
  };
}
