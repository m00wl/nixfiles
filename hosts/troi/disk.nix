{ disko, ... }:
let
  disks = [ "/dev/vda" ];
in
{
  disko.devices = {
    disk.main = {
      device = builtins.elemAt disks 0;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=077" ];
            };
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
