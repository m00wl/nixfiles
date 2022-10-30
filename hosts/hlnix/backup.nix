{ config, pkgs, ...}:

let
  cfg = config.services.borgbackup;
  mount-slnix = pkgs.writeShellScriptBin "mount-slnix" ''
    set -eu
    set -o pipefail
    mkdir /tmp/sshfs
    ${pkgs.sshfs}/bin/sshfs backup@moritz.lumme.de:/data/ /tmp/sshfs -F /run/secrets/ssh/moritz -o IdentityFile=/run/secrets/ssh/id_ed25519_slnix-borg
  '';
  umount-slnix = pkgs.writeShellScriptBin "umount-slnix" ''
    set -eu
    set -o pipefail
    ${pkgs.umount}/bin/umount /tmp/sshfs
    rmdir /tmp/sshfs
  '';
in
{
  # Configure borgbackup repos.
  services.borgbackup.repos = {
    slnix = {
      path = "/data/borgbackup/slnix";
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMDMZ8aIbzb709hde3ggnTito4Y5QdXwce6VnekIBPap"
      ];
    };
  };

  # Configure backup for slnix.
  sops.secrets = {
    "ssh/id_ed25519_slnix-borg" = {
      sopsFile = ./secrets.yaml;
      owner = cfg.jobs.slnixBackup.user;
      group = cfg.jobs.slnixBackup.group;
    };
    "ssh/moritz" = {
      sopsFile = ./secrets.yaml;
      owner = cfg.jobs.slnixBackup.user;
      group = cfg.jobs.slnixBackup.group;
    };
    "borg/repo-pwds/slnix" = {
      sopsFile = ./secrets.yaml;
      owner = cfg.jobs.slnixBackup.user;
      group = cfg.jobs.slnixBackup.group;
    };
  };

  services.borgbackup.jobs = {
    slnixBackup = {
      paths = "/tmp/sshfs";
      repo = "/data/borgbackup/slnix";
      encryption = {
        mode = "repokey";
        passCommand = "cat /run/secrets/borg/repo-pwds/slnix";
      };
      compression = "auto,lzma";
      startAt = "*-*-* 04:00:00";
      prune.keep = {
        within = "1d"; # Keep all archives from the last day
        daily = 7;
        weekly = 4;
        monthly = -1;  # Keep at least one archive for each month
      };
      preHook = ''
        ${mount-slnix}/bin/mount-slnix
      '';
      postHook = ''
        ${umount-slnix}/bin/umount-slnix
      '';
      persistentTimer = true;
      extraCreateArgs = "--numeric-ids";
    };
  };
}
