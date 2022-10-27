{ config, pkgs, ... }:

{
  # Create backup user account
  users.users.backup = {
    isSystemUser = true;
    group = "backup";
    extraGroups = [ "users" ];
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMDMZ8aIbzb709hde3ggnTito4Y5QdXwce6VnekIBPap backup@slnix"
    ];
  };

  users.groups.backup = {};
}
