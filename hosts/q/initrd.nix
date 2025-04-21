{ config, ... }:

{
  boot = {
    initrd = {
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 22;
          shell = "/bin/cryptsetup-askpass";
          authorizedKeyFiles = [ ../../users/m00wl/id_ed25519_mwl.pub ];
          hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
        };
      };
      availableKernelModules = [ "e1000" ];
    };
    kernelParams = [ "ip=dhcp" ];
  };
}
