{ pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    matchBlocks = {
      "home.lumme.de" = {
        user = "m00wl";
        port = 10022;
        identityFile = [ "/home/m00wl/.ssh/id_ed25519_mwl" ];
      };
    };
  };
}

