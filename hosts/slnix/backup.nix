{ config, pkgs, ... }:

let
  cfg = config.services.borgbackup;
in
{
  sops.secrets = {
    "backup/ssh-key" = {
      sopsFile = ./secrets.yaml;
      owner = cfg.jobs.data.user;
      group = cfg.jobs.data.group;
    };
    "backup/repo-pwd" = {
      sopsFile = ./secrets.yaml;
      owner = cfg.jobs.data.user;
      group = cfg.jobs.data.group;
    };
  };

  services.borgbackup.jobs = {
    data = {
      paths = "/data";
      environment.BORG_RSH = "ssh -i /run/secrets/backup/ssh-key";
      repo = "borg@bak.lumme.de:/srv/backup/slnix";
      encryption = {
        mode = "repokey";
        passCommand = "cat /run/secrets/backup/repo-pwd";
      };
      compression = "auto,lzma";
      startAt = "*-*-* 04:00:00";
      prune.keep = {
        within = "1d"; # Keep all archives from the last day.
        daily = 7;
        weekly = 4;
        monthly = -1;  # Keep at least one archive for each month.
      };
      persistentTimer = true;
    };
  };
}
