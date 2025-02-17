{ disko, ... }:
let
  disks = [ "/dev/nvme0n1" ];
in
{
  disko.devices = {
    disk.nvme0n1 = {
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
          luks = {
            end = "-8G";
            content = {
              type = "luks";
              name = "crypted";
              settings.allowDiscards = true;
              # don't set passwordFile here -> disko asks during installation.
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
          swap = {
            size = "100%";
            content = {
              type = "swap";
              randomEncryption = true;
              discardPolicy = "both";
            };
          };
        };
      };
    };
    nodev = {
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [ "size=512M" ];
      };
    };
  };
}
