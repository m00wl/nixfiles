{ config, ... }:

{
  boot = {
    initrd = {
      availableKernelModules = [ "e1000e" ];
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
    };
    kernelParams = [ "ip=::::${config.networking.hostName}::dhcp" ];
  };
}
