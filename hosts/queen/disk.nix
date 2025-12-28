{ disko, ... }:
let
  disks = [ "/dev/sda" ];
in
{
  disko.devices = {
    disk.main = {
      device = builtins.elemAt disks 0;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
              size = "1M";
              type = "EF02";
              #attributes = [ 0 ];
          };
          swap = {
              size = "2G";
              content = {
                type = "swap";
                discardPolicy = "both";
              };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
    nodev."/tmp".fsType = "tmpfs";
  };
}
