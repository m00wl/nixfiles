{ pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    includes = [
      "/run/secrets/openssh.service/home.lumme.de"
      "/run/secrets/openssh.service/git.lumme.de"
    ];
  };
}

