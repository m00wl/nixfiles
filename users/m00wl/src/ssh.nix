{ pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    includes = [
      "/run/secrets/ssh/home"
      "/run/secrets/ssh/git-server"
    ];
  };
}

