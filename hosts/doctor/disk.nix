{ disko, ... }:
let
  disks = [ "/dev/sda" ];
in
{
  disko.devices.disk.sda = {
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
          };
        };
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "crypted";
            extraOpenArgs = [ "--allow-discards" ];
            # don't set passwordFile here -> disko asks during installation.
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
