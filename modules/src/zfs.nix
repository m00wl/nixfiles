{ config, pkgs, ...}:

{
  # Enable zfs
  boot.supportedFilesystems = [ "zfs" ];

  # Enable zfs services
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  # Remember to set 'networking.hostId' to $(head -c 8 /etc/machine-id)
  # in configuration.nix
}
