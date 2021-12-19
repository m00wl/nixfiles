
{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Moritz Lumme";
    userEmail = "46034439+m-lumme@users.noreply.github.com";
    extraConfig = {
      core = {
        editor = "vim";
      };
      color = {
        ui = "auto";
      };
      init = {
        defaultBranch = "main";
      };
      diff = {
        tool = "vim -d";
      };
      merge = {
        tool = "vim -d";
      };
    };
  };
}

