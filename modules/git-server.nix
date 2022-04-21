{ config, pkgs, ...}:

let
  github-mirror = pkgs.writeShellScriptBin "github-mirror" ''
    echo "mirroring to github"
    GH_USER=$GL_USER
    GH_REPO=$GL_REPO
    [ ! -f ~/github/pat_$GH_USER ] && echo "error: no personal access token found"
    GH_TOKEN=$(cat ~/github/pat_$GL_USER)
    echo "git push https://<GH_PAT>@github.com/$GH_USER/$GH_REPO.git"
    git push https://$GH_TOKEN@github.com/$GH_USER/$GH_REPO.git
  '';
in
{
  # Enable gitolite service
  services.gitolite = {
    enable = true;
    user = "git";
    group = "git";
    dataDir = "/srv/git";
    adminPubkey = builtins.elemAt config.users.users.m00wl.openssh.authorizedKeys.keys 0;
    extraGitoliteRc = ''
      $RC{UMASK} = 0027;
      #$RC{ROLES}{ADMINS} = 1;
      $RC{LOCAL_CODE} = "${config.services.gitolite.dataDir}/local";
      push( @{$RC{ENABLE}}, 'repo-specific-hooks' );
    '';
  };

  # Automatically create git user home dir, local folder structure to override non-core gitolite components and github-mirror hook
  systemd.tmpfiles.rules = [
    "d ${config.services.gitolite.dataDir}                                          0750 ${config.services.gitolite.user} ${config.services.gitolite.group} -"
    "d ${config.services.gitolite.dataDir}/local                                    0750 ${config.services.gitolite.user} ${config.services.gitolite.group} -"
    "d ${config.services.gitolite.dataDir}/local/commands                           0750 ${config.services.gitolite.user} ${config.services.gitolite.group} -"
    "d ${config.services.gitolite.dataDir}/local/hooks/                             0750 ${config.services.gitolite.user} ${config.services.gitolite.group} -"
    "d ${config.services.gitolite.dataDir}/local/hooks/common                       0750 ${config.services.gitolite.user} ${config.services.gitolite.group} -"
    "d ${config.services.gitolite.dataDir}/local/hooks/repo-specific                0750 ${config.services.gitolite.user} ${config.services.gitolite.group} -"
    "d ${config.services.gitolite.dataDir}/local/lib/                               0750 ${config.services.gitolite.user} ${config.services.gitolite.group} -"
    "d ${config.services.gitolite.dataDir}/local/lib/Gitolite/                      0750 ${config.services.gitolite.user} ${config.services.gitolite.group} -"
    "d ${config.services.gitolite.dataDir}/local/lib/Gitolite/Triggers              0750 ${config.services.gitolite.user} ${config.services.gitolite.group} -"
    "d ${config.services.gitolite.dataDir}/local/syntactic-sugar                    0750 ${config.services.gitolite.user} ${config.services.gitolite.group} -"
    "d ${config.services.gitolite.dataDir}/local/triggers                           0750 ${config.services.gitolite.user} ${config.services.gitolite.group} -"
    "d ${config.services.gitolite.dataDir}/local/VREF                               0750 ${config.services.gitolite.user} ${config.services.gitolite.group} -"
    "L ${config.services.gitolite.dataDir}/local/hooks/repo-specific/github-mirror - - - - ${github-mirror}/bin/github-mirror"
  ];

  # Set default branch name to main
  home-manager.users.${config.services.gitolite.user} = {
    programs.git = {
      enable = true;
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };
  };

  # Enable gitweb through nginx
  services.nginx.gitweb = {
    enable = true;
    group = config.services.gitolite.group;
    virtualHost = "git.lumme.de";
    location = "";
  };

  # Point gitweb to bare repos
  services.gitweb = {
    projectroot = "${config.services.gitolite.dataDir}/repositories";
    extraConfig = ''
      $projects_list = "${config.services.gitolite.dataDir}/projects.list";
      $strict_export = true;
      $home_link_str = "git.lumme.de";
      $site_name = "git.lumme.de";
    '';
  };
}
