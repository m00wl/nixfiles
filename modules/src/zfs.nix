{
  # Enable zfs.
  boot.supportedFilesystems = [ "zfs" ];

  # Enable zfs services.
  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
    autoSnapshot.enable = true;
  };

  # Remember to set 'networking.hostId' to $(head -c 8 /etc/machine-id).
}
