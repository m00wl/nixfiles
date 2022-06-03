{ config, pkgs, lib, ... }:

let
  cfg = config.services.radicale;
  user = config.users.users.radicale.name;
  group = config.users.groups.radicale.name;
  # Radicale initialization
  radicale-init = pkgs.writeShellScriptBin "radicale-init" ''
    set -eu
    set -o pipefail

    if [ ! $# -eq 1 ]; then
      echo "error: Wrong number of arguments"
      echo "usage: radicale-init [DIR]"
      exit 1
    fi

    if [ ! -d $1 ]; then
      echo "$0: Directory $1 does not exist"
      exit 1
    fi

    if [ ! -d $1/.git ]; then
      cd $1
      ${pkgs.git}/bin/git init
      ${pkgs.git}/bin/git config user.email "radicale@rc.lumme.de"
      ${pkgs.git}/bin/git config user.name "Radicale Git"
      if [ ! -e .gitignore ]; then
        echo -e ".Radicale.cache\n.Radicale.lock\n.Radicale.tmp-*" > .gitignore
      fi
    fi
  '';

  # Radicale locations
  runtimeDir = "/var/lib/radicale/collections";
  backupDir = "/data/backup/rc";
in
{
  # Enable Radicale CalDAV/CardDAV server
  services.radicale = {
    enable = true;
    settings = {
      auth = {
        # Reverse proxy does http basic auth for us
        type = "http_x_remote_user";
      };
      storage =
        # Configure automatic git commit on every write to storage
        let
          git = "${pkgs.git}/bin/git";
        in {
          hook = ''
            ${git} add -A && (${git} diff --cached --quiet || ${git} commit -m "Changes by %(user)s")
          '';
          filesystem_folder = runtimeDir;
      };
      web = {
        # Disable web interface
        type = "none";
      };
    };
    rights = {

    };
  };

  # Initialize git repo for versioning of changes
  systemd.services.radicale.preStart = "${radicale-init}/bin/radicale-init ${runtimeDir}";

  # Add subdomain to base cert
  security.acme.certs."moritz.lumme.de".extraDomainNames = [ "rc.lumme.de" ];

  # Configure reverse proxy
  services.nginx = {
    virtualHosts."rc.lumme.de" = {
      useACMEHost = "moritz.lumme.de";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:5232";
        extraConfig = ''
          proxy_set_header X-Script-Name "";
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Remote-User $remote_user;
          proxy_set_header Host $host;
        '';
      };
    };
  };

  # Initialize runtime and backup dirs
  systemd.tmpfiles.rules = [
    "d ${backupDir} 0755 ${user} ${config.users.groups.users.name} -"
  ];

  # Backup
  systemd.services.radicale-backup = {
    description = "Periodic backup of radicale collections";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    unitConfig.RequiresMountsFor = backupDir;
    serviceConfig = {
      Type = "oneshot";
      User = user;
      Group = group;
    };
    path = [
      pkgs.gnutar
      pkgs.gzip
      pkgs.flock
    ];
    script = ''
      set -eu
      set -o pipefail
      SRC=${runtimeDir}
      SRC_PATH=$(dirname $SRC)
      SRC_NAME=$(basename $SRC)
      BACKUP_DIR=${backupDir}
      BACKUP_LOCK=$SRC/.Radicale.lock
      BACKUP_CMD="tar -C $SRC_PATH -cpzf $BACKUP_DIR/$SRC_NAME.tgz.back $SRC_NAME"
      flock $BACKUP_LOCK $BACKUP_CMD
    '';
    startAt = [ "*-*-* 03:00:00" ];
  };
}
