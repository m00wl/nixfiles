{ config, pkgs, ... }:

{
  # Define backup here.
  services.borgbackup.repos = {
    slnix = {
      path = "/srv/backup/slnix";
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICDE1KJeqyaECQKZi3RcigLXOWKeIKG6yCnSZ9Oj/FJR backup-slnix"
      ];
    };
  };

}
