{ config, ... }:
{
  # Create 'charl00w' user account.
  users.users.charl00w = {
    isNormalUser = true;
    extraGroups = [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBvyPbbInFU00pao5RB1ju2gZkELeg0iuLsZtA1HBBen charl00w@home"
    ];
  };
}
