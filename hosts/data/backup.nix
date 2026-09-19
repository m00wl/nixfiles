{ config, pkgs, ... }:
let
  lock = "/var/lib/borgbackup-nextcloud/lock";
  occ = "${config.services.nextcloud.occ}/bin/nextcloud-occ";
  user = config.services.borgbackup.jobs.nextcloud-seven.user;
  group = config.services.borgbackup.jobs.nextcloud-seven.group;

  makeBorgJob = target: {
    paths = config.services.nextcloud.datadir;
    environment.BORG_RSH = "ssh -i /root/borgbackup/id_ed25519_borg_${target}";
    encryption = {
      mode = "repokey";
      passCommand = "cat /root/borgbackup/repopass_${target}";
    };
    compression = "auto,lzma";
    readWritePaths = [
      config.services.nextcloud.datadir
      lock
    ];
    preHook = ''
      exec 200>${lock}
      ${pkgs.util-linux}/bin/flock -x 200
      ${occ} maintenance:mode --on
    '';
    postHook = ''
      ${occ} maintenance:mode --off
      exec 200>&-
    '';
    prune.keep = {
      daily = 7;
      weekly = 4;
      monthly = 12;
      yearly = -1;
    };
  };
in
{
  systemd.tmpfiles.rules = [
    "f ${lock} 0660 ${user} ${group} -"
  ];

  services.borgbackup.jobs = {
    nextcloud-seven = (makeBorgJob "seven") // {
      repo = "borg@seven:.";
    };

    nextcloud-queen = (makeBorgJob "queen") // {
      repo = "borg@bak.lum.me:.";
    };
  };
}
