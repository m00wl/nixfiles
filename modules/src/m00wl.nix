{ config, ... }:
{
  # Create 'm00wl' user account.
  users.users.m00wl = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [
      ../../users/m00wl/id_ed25519_mwl.pub
    ];
  };
}
