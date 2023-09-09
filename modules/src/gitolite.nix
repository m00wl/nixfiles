{ config, pkgs, ...}:
let
  cfg = config.services.gitolite;
  admin = config.users.users.m00wl;
  dmn = "git.lumme.de";
  backupDir = "/data/backup/git";
  github-mirror = pkgs.writeShellScriptBin "github-mirror" ''
    set -eu
    set -o pipefail
    echo "mirroring to github"
    GH_USER=$GL_USER
    GH_REPO=$(basename $GL_REPO)
    if [ ! -f /run/secrets/github/$GH_USER-pat-mirror ]; then
      echo "error: no personal access token found"
      exit 1
    fi
    GH_TOKEN=$(cat /run/secrets/github/$GH_USER-pat-mirror)
    git push --mirror https://$GH_TOKEN@github.com/$GH_USER/$GH_REPO.git
  '';
in
{
  # Retrieve PATs from sops
  sops.secrets."github/m00wl-pat-mirror" = {
    sopsFile = ../../hosts/slnix/secrets.yaml;
    owner = cfg.user;
    group = cfg.group;
  };

  # Enable gitolite service
  services.gitolite = {
    enable = true;
    user = "git";
    group = "git";
    # Default:
    #dataDir = "/var/lib/gitolite";
    adminPubkey = builtins.elemAt admin.openssh.authorizedKeys.keys 0;
    extraGitoliteRc = ''
      $RC{UMASK} = 0027;
      #$RC{ROLES}{ADMINS} = 1;
      $RC{LOCAL_CODE} = "${cfg.dataDir}/local";
      push( @{$RC{ENABLE}}, 'repo-specific-hooks' );
    '';
  };

  # Automatically create git user home dir,
  # local folder structure to override non-core gitolite components,
  # github-mirror hook
  # and backup dir
  systemd.tmpfiles.rules = [
    "d ${cfg.dataDir}/local                       0750 ${cfg.user} ${cfg.group} -"
    "d ${cfg.dataDir}/local/commands              0750 ${cfg.user} ${cfg.group} -"
    "d ${cfg.dataDir}/local/hooks/                0750 ${cfg.user} ${cfg.group} -"
    "d ${cfg.dataDir}/local/hooks/common          0750 ${cfg.user} ${cfg.group} -"
    "d ${cfg.dataDir}/local/hooks/repo-specific   0750 ${cfg.user} ${cfg.group} -"
    "d ${cfg.dataDir}/local/lib/                  0750 ${cfg.user} ${cfg.group} -"
    "d ${cfg.dataDir}/local/lib/Gitolite/         0750 ${cfg.user} ${cfg.group} -"
    "d ${cfg.dataDir}/local/lib/Gitolite/Triggers 0750 ${cfg.user} ${cfg.group} -"
    "d ${cfg.dataDir}/local/syntactic-sugar       0750 ${cfg.user} ${cfg.group} -"
    "d ${cfg.dataDir}/local/triggers              0750 ${cfg.user} ${cfg.group} -"
    "d ${cfg.dataDir}/local/VREF                  0750 ${cfg.user} ${cfg.group} -"
    "d ${backupDir}                               0755 ${cfg.user} ${config.users.groups.users.name} -"
    "L+ ${cfg.dataDir}/local/hooks/repo-specific/github-mirror - - - - ${github-mirror}/bin/github-mirror"
  ];

  # Set default branch name to main
  home-manager.users.${cfg.user} = {
    programs.git = {
      enable = true;
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };
    home.stateVersion = "21.11";
  };

  # Configure automatic backup service
  systemd.services.gitolite-backup = {
    description = "Periodic backup of gitolite repositories";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    unitConfig.RequiresMountsFor = backupDir;
    serviceConfig = {
      Type = "oneshot";
      User = cfg.user;
      Group = cfg.group;
      WorkingDirectory = "~";
    };
    path = config.systemd.services.gitolite-init.path ++ [
      pkgs.gnutar
      pkgs.gzip
    ];
    script = ''
      set -eu
      set -o pipefail
      REPOS_DIR=${cfg.dataDir}/repositories
      BACKUP_DIR=${backupDir}
      gitolite writable @all off "Backup in progress. Please try again at a later point in time."
      test -d $BACKUP_DIR || mkdir $BACKUP_DIR
      SRC_PATH=$(dirname $REPOS_DIR)
      SRC_NAME=$(basename $REPOS_DIR)
      tar -C $SRC_PATH -cpzf $BACKUP_DIR/$SRC_NAME.tgz.back $SRC_NAME
      gitolite writable @all on
    '';
    startAt = [ "*-*-* 03:00:00" ];
  };

  # Enable gitweb through nginx
  services.nginx.gitweb = {
    enable = true;
    group = cfg.group;
    virtualHost = dmn;
    location = "";
  };

  # Add subdomain to base cert
  security.acme.certs."moritz.lumme.de".extraDomainNames = [ dmn ];

  # Configure reverse proxy
  services.nginx.virtualHosts.${dmn} = {
    useACMEHost = "moritz.lumme.de";
  };

  # Point gitweb to bare repos
  services.gitweb = {
    projectroot = "${cfg.dataDir}/repositories";
    extraConfig = ''
      $projects_list = "${cfg.dataDir}/projects.list";
      $strict_export = true;
      $home_link_str = "${dmn}";
      $site_name = "${dmn}";
      $omit_owner = true;
    '';
  };
}
